# Dr. Mario

An implementation of the classic puzzle game **Dr. Mario**, written entirely in **MIPS Assembly Language**.

## Authors
* **Zhu Xin Sun (Julie)**
* **Yuchen Zhao**

---

## Project Overview

This project brings a fully interactive, feature-rich version of *Dr. Mario* to the MIPS architecture. Utilizing low-level system design patterns, direct memory-mapped I/O (MMIO), and structural memory grids, the game incorporates robust gameplay elements including dynamic capsule manipulation, recursive drop cascades, color matching elimination, and responsive audio-visual feedback.

### Key Features
* **Dynamic Difficulty Configuration:** Three selectable tiers (Easy, Medium, Hard) that adjust capsule gravity fall-rates and the initial virus load.
* **Advanced Puzzle Engine:** Seamlessly evaluates both horizontal and vertical 4-in-a-row connections for pill-capsules and viruses.
* **Cascade Physics:** Includes a sophisticated cascade mechanic that automatically triggers recursive column falling when underlying structures are cleared.
* **Multi-Capsule Queue Preview:** A 4-stage pipeline queue display on the right-hand panel previews upcoming capsule color combinations.
* **Custom Pixel Art Artworks:** Features custom sprite renderings including a detailed *Capybara* companion and multi-colored animated viruses.
* **Chiptune Audio Integration:** Utilizes synchronous MIDI system calls to produce distinct sounds for capsule movement, pill rotation, line elimination, and game-over states.

---

## Architecture & System Configuration

To run the game correctly, the MIPS emulator must be configured with a specific peripheral layout.

### 1. Bitmap Display Configuration
The graphical interface relies on MARS or Spim's memory-mapped **Bitmap Display** tool connected to the global pointer address space.
* **Unit Width in Pixels:** 1
* **Unit Height in Pixels:** 1
* **Display Width in Pixels:** 64
* **Display Height in Pixels:** 64
* **Base Address for Display:** `0x10008000` (`$gp`)

### 2. Keyboard Configuration
User input handling utilizes memory-mapped register polls via the **Keyboard and Display MMIO Simulator**.
* **Base Address for Keyboard:** `0xffff0000`

### 3. Grid & State Core Layout
* **Bottle Grid Space:** The functional gameplay matrix is centered within coordinates `(9, 25)` spanning an `18x25` sector.
* **Memory Arrays:**
  * `BOTTLE_GRID`: A 450-word matrix tracking the current cell colors (`0` = Black/Empty, `1` = Red, `2` = Yellow, `3` = Blue).
  * `LINK`: Tracks joint connection physics between segment pairs of falling capsules (`1` for primary capsule block, `-1` for secondary segment pair).

---

## Input Controls Reference

| Key | Action | Function |
| :---: | :--- | :--- |
| **`e`** | Select Easy Level | Initiates game with low gravity speed and 4 viruses. |
| **`m`** | Select Medium Level | Initiates game with balanced gravity speed and 5 viruses. |
| **`h`** | Select Hard Level | Initiates game with fast gravity speed and 6 viruses. |
| **`a`** | Move Left | Slides the falling capsule one column to the left. |
| **`d`** | Move Right | Slides the falling capsule one column to the right. |
| **`s`** | Move Down | Accelerates the capsule's downward velocity manually. |
| **`w`** | Rotate | Flips capsule orientation between horizontal and vertical axes. |
| **`p`** | Pause / Unpause | Halts gameplay loop execution; clears overlay on resume. |
| **`r`** | Restart | Resets board grids, gravity counters, and loads level screen (Game Over only). |
| **`q`** | Quit Game | Instantly terminates thread execution and triggers Game Over sequence. |

---

## Technical Implementation Details

### Game Loop Execution
The core loop operates systematically at fixed intervals (`16ms` cycle sleep), continuously coordinating:
1. Frame rendering and layout buffers (`draw_capsule`, `draw_upcoming_capsules`, `draw_bottle`).
2. Edge-triggered keyboard polling routines.
3. Automated time-sliced physics iterations via the `gravity` routine.

### Elimination and Cascade Mechanics
When a capsule lands, the game halts user inputs to execute the `cascade` function:
* It scans both axes using lookahead boundaries to clear configurations matching **4 identical colored blocks**.
* If pieces become unsuspended, a reverse vertical scan loop `drop` iterates upward from the floor, moving freestanding blocks downward onto solid objects.
* The loop runs recursively until a full sweep detects zero state transitions, ensuring chained clearing combinations work correctly.

---

## Installation & Launch Procedures

1. Open **MARS or Saturn**.
2. Load the source code file: `drmario.asm`.
3. Open the **Bitmap Display** tool (`Tools -> Bitmap Display`) and apply the settings detailed in the [Configuration](#1-bitmap-display-configuration) section, then click **Connect to MIPS**.
4. Open the **Keyboard and Display MMIO Simulator** tool (`Tools -> Keyboard and Display MMIO Simulator`) and click **Connect to MIPS**.
5. Execute the software (`F5` or `Run -> Go`).
6. Click inside the **Keyboard Simulator text entry area** to input choices and control your capsule segments.
