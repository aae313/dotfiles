#!/usr/bin/env python3

import json
import os
import socket
import sys


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


def parse_delta(argument):
    if not argument or argument[0] not in "+-":
        raise ValueError("expected an argument like '+', '-', '+5', or '-2.5'")

    magnitude = argument[1:]
    delta = float(magnitude) if magnitude else 5.0
    if delta <= 0:
        raise ValueError("the step must be positive")

    return delta if argument[0] == "+" else -delta


def main():
    if len(sys.argv) != 2:
        raise ValueError("usage: resize-two-column-widths.py <+[step]|-[step]>")

    delta = parse_delta(sys.argv[1])

    niri = Niri()
    try:
        workspaces = niri.request("Workspaces")["Workspaces"]
        focused_workspace = next(
            (workspace for workspace in workspaces if workspace["is_focused"]), None
        )
        if focused_workspace is None:
            raise RuntimeError("no workspace is focused")

        windows = niri.request("Windows")["Windows"]
        columns = {}

        for window in windows:
            layout = window.get("layout", {})
            position = layout.get("pos_in_scrolling_layout")

            if (
                window.get("workspace_id") != focused_workspace["id"]
                or window.get("is_floating")
                or position is None
            ):
                continue

            columns.setdefault(position[0], window["id"])

        if len(columns) < 2:
            raise RuntimeError("the focused workspace has fewer than two tiled columns")

        left_id, right_id = (columns[index] for index in sorted(columns)[:2])

        for window_id, change in ((left_id, delta), (right_id, -delta)):
            niri.action(
                {
                    "SetWindowWidth": {
                        "id": window_id,
                        "change": {"AdjustProportion": change},
                    }
                }
            )
    finally:
        niri.close()


if __name__ == "__main__":
    try:
        main()
    except (KeyError, OSError, RuntimeError, TypeError, ValueError) as error:
        print(f"resize-two-column-widths: {error}", file=sys.stderr)
        raise SystemExit(1)
