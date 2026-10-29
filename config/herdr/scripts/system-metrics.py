#!/usr/bin/env python3
import re
import subprocess


def main():
    result = subprocess.run(
        ["/usr/bin/top", "-l", "2", "-s", "1", "-n", "0"],
        capture_output=True, text=True, check=True, env={"LC_ALL": "C"},
    )
    cpu = re.findall(r"CPU usage:.*?([\d.]+)% idle", result.stdout)
    memory = re.findall(r"PhysMem: ([\d.]+)([KMGT]) used .*?, ([\d.]+)([KMGT]) unused", result.stdout)
    if not cpu or not memory:
        raise ValueError("top output does not contain CPU and memory usage")
    used, used_unit, free, free_unit = memory[-1]
    units = {unit: 1024 ** index for index, unit in enumerate("KMGT")}
    used = float(used) * units[used_unit]
    free = float(free) * units[free_unit]
    print(f"󰻠 CPU {100 - float(cpu[-1]):.0f}%  󰍛 MEM {100 * used / (used + free):.0f}%")


if __name__ == "__main__":
    main()
