#!/usr/bin/env python3

import json
import math
import os
import socket
import sys
import time


class Niri:
    def __init__(self):
        socket_path = os.environ.get("NIRI_SOCKET")
        if not socket_path:
            raise RuntimeError("NIRI_SOCKET is not set")

        self.socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self.socket.connect(socket_path)
        self.stream = self.socket.makefile("rwb")

    def close(self):
        self.stream.close()
        self.socket.close()

    def request(self, payload):
        self.stream.write(json.dumps(payload, separators=(",", ":")).encode() + b"\n")
        self.stream.flush()

        line = self.stream.readline()
        if not line:
            raise RuntimeError("niri closed the IPC socket without replying")

        reply = json.loads(line)
        if "Err" in reply:
            raise RuntimeError(reply["Err"])
        if "Ok" not in reply:
            raise RuntimeError("niri returned an invalid IPC reply")

        return reply["Ok"]

    def action(self, action):
        self.request({"Action": action})


def main():
    niri = Niri()
    try:
        workspaces = niri.request("Workspaces")["Workspaces"]
        focused_workspace = next(
            (workspace for workspace in workspaces if workspace["is_focused"]), None
        )
        if focused_workspace is None:
            raise RuntimeError("no workspace is focused")

        windows = niri.request("Windows")["Windows"]
        focused_window = next(
            (window for window in windows if window.get("is_focused")),
            None,
        )
        columns = {}

        for window in windows:
            layout = window.get("layout", {})
            position = layout.get("pos_in_scrolling_layout")
            tile_size = layout.get("tile_size")

            if (
                window.get("workspace_id") != focused_workspace["id"]
                or window.get("is_floating")
                or position is None
                or tile_size is None
            ):
                continue

            columns.setdefault(position[0], (tile_size[0], window["id"]))

        if len(columns) < 2:
            raise RuntimeError("the focused workspace has fewer than two tiled columns")

        (left_width, left_id), (right_width, right_id) = (
            columns[index] for index in sorted(columns)[:2]
        )

        if math.isclose(left_width, right_width, rel_tol=0.02, abs_tol=2):
            next_widths = (75.0, 25.0)
        # elif left_width > right_width:
        #     next_widths = (100 / 3, 200 / 3)
        else:
            next_widths = (50.0, 50.0)

        for window_id, width in ((left_id, next_widths[0]), (right_id, next_widths[1])):
            niri.action(
                {"SetWindowWidth": {"id": window_id, "change": {"SetProportion": width}}}
            )

        focused_column = next(
            window["layout"]["pos_in_scrolling_layout"][0]
            for window in windows
            if window["is_focused"]
        )

        if focused_column == 2:
            niri.action({"FocusColumnFirst": {}})
            time.sleep(0.05)
            niri.action({"FocusColumnRight": {}})
            print(focused_column)
    finally:
        niri.close()


if __name__ == "__main__":
    try:
        main()
    except (KeyError, OSError, RuntimeError, TypeError, ValueError) as error:
        print(f"cycle-two-column-widths: {error}", file=sys.stderr)
        raise SystemExit(1)
