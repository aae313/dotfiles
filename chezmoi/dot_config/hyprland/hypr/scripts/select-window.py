#!/usr/bin/env python3
import json
import subprocess
import sys
from dataclasses import dataclass
from typing import List, Optional

@dataclass
class Client:
    idx: int
    ws: int
    cls: str
    title: str
    addr: str
    def display(self) -> str:
        ws_str = "[S]" if self.ws == -99 else f"[{self.ws}]"
        cls_str = f"{self.cls[:24]:<24}"
        return f"{self.idx:2d} {ws_str:4} {cls_str} │ {self.title}"

def get_clients() -> List[Client]:
    try:
        result = subprocess.run(
            ["hyprctl", "-j", "clients"],
            capture_output=True,
            text=True,
            check=True
        )
        data = json.loads(result.stdout)
    except (subprocess.CalledProcessError, json.JSONDecodeError):
        return []
    clients = []
    for i, c in enumerate(
        (
            c for c in data
            if c.get("mapped")
            and 1 <= (c.get("workspace") or {}).get("id", -1) <= 9
        ),
        1
    ):
        ws_id = (c.get("workspace") or {}).get("id", -1)
        if addr := c.get("address"):
            clients.append(Client(
                idx=i,
                ws=ws_id,
                cls=c.get("class", "unknown"),
                title=c.get("title", ""),
                addr=addr
            ))
    return clients


def select_client(clients: List[Client]) -> Optional[str]:
    if not clients:
        return None
    menu = "\n".join(c.display() for c in clients)
    res = subprocess.run(
        ["fuzzel", "--dmenu", "--no-icons", "--index", "--width", "100", "--output", "DP-1"],
        input=menu,
        capture_output=True,
        text=True
    )
    if not res.stdout:
        return None
    try:
        idx = int(res.stdout.strip())
        return clients[idx].addr
    except (ValueError, IndexError):
        return None


def main() -> None:
    clients = get_clients()
    if not clients:
        sys.exit(0)
    if addr := select_client(clients):
        subprocess.run(
            ["hyprctl", "dispatch", f'hl.dsp.focus({{ window = "address:{addr}" }})'], check=False,
)


if __name__ == "__main__":
    main()
