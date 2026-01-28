# Vortex

A lightweight system monitor for the Linux terminal.

Vortex is a small project I built to learn about Linux system internals and process synchronization. It provides a real-time snapshot of system vitals by communicating directly with the kernel, avoiding the overhead of larger, complex monitoring suites.

## Features

* **Asynchronous Processing:** Uses a background subshell to gather data, ensuring the UI remains responsive.
* **Zero Dependencies:** Relies only on native Bash and the `/proc` filesystem.
* **Clean UI:** Uses the terminal's alternate screen buffer to provide a full-screen experience that doesn't clutter your terminal history.
* **Inter-Process Communication:** Implements Unix Named Pipes (FIFOs) to pass data between logic and display layers.



## How It Works

The script is divided into two parts:
1.  **The Collector:** Runs in the background, reading raw byte-streams from `/proc/meminfo`, `/proc/loadavg`, and `/proc/net/dev`.
2.  **The Renderer:** Interprets that data and formats it into a readable dashboard using `tput` for precise cursor positioning.

## Installation

```bash
# Clone the repository
git clone https://github.com/yxngrbree/vortex.git

# Enter the directory
cd vortex

# Make the script executable
chmod +x vortex.sh

```
To make this easy for you, I’ve combined everything into one block below. You can copy the entire content and paste it directly into a file named README.md in your GitHub repository.

Markdown

# Vortex

A humble, lightweight system monitor for the Linux terminal.

Vortex is a small project I built to learn about Linux system internals and process synchronization. It provides a real-time snapshot of system vitals by communicating directly with the kernel, avoiding the overhead of larger, complex monitoring suites.

## Features

* **Asynchronous Processing:** Uses a background subshell to gather data, ensuring the UI remains responsive.
* **Zero Dependencies:** Relies only on native Bash and the `/proc` filesystem.
* **Clean UI:** Uses the terminal's alternate screen buffer to provide a full-screen experience that doesn't clutter your terminal history.
* **Inter-Process Communication:** Implements Unix Named Pipes (FIFOs) to pass data between logic and display layers.



## How It Works

The script is divided into two parts:
1.  **The Collector:** Runs in the background, reading raw byte-streams from `/proc/meminfo`, `/proc/loadavg`, and `/proc/net/dev`.
2.  **The Renderer:** Interprets that data and formats it into a readable dashboard using `tput` for precise cursor positioning.

## Installation

```bash
# Clone the repository
git clone [https://github.com/YOUR_USERNAME/vortex.git](https://github.com/yxngrbree/vortex.git)
```
# Enter the directory
```
cd vortex
```
# Make the script executable
```
chmod +x vortex.sh
```
```
Usage
Run the script directly from your terminal:
```
Bash
```
./vortex.sh
```
