🔐 Intrusion Detection System

The Intrusion Detection System is an Assembly Language-based security project developed using the 8086 microprocessor. It provides a secure login mechanism to prevent unauthorized access by monitoring login attempts and detecting suspicious activities.

The system automatically locks access after three consecutive failed login attempts and generates a security alert.

🎯 Project Objectives

- Implement secure login authentication.
- Detect unauthorized login attempts.
- Monitor failed and successful login attempts.
- Automatically lock the system after repeated failures.
- Display security status and login records.
- Provide a system reset option.

✨ Features

- Secure Login: Validates username and password.
- Password Masking: Displays `*` instead of the actual password.
- Failed Attempt Counter: Tracks incorrect login attempts.
- Intrusion Detection: Detects three failed login attempts.
- Automatic System Lock: Locks the system after reaching the attempt limit.
- Security Alert: Displays a warning and generates an alert beep.
- Security Status: Shows failed attempts, successful logins, and system status.
- Reset System: Clears counters and restores the system to a secure state.

🛠️ Technologies Used

- Assembly Language (8086)
- DOS Interrupts (INT 21H)
- EMU8086 / MASM-compatible environment

🔑 Login Credentials

For testing purposes, the predefined credentials are:

| Field                   | Value   |
| ----------------------- | ------- |
| Username                | `mahek` |
| Password                | `1234`  |
| Maximum Failed Attempts | `3`     |

Note: These credentials are hardcoded for educational demonstration purposes.

📋 Main Menu Options

1. Secure Login
2. Security Status / Log
3. Reset Security System
4. Exit

⚙️ How It Works

1. The user selects Secure Login from the main menu.
2. The system requests a username and password.
3. The entered credentials are checked against predefined credentials.
4. If correct, access is granted and the successful login counter increases.
5. If incorrect, the failed login counter increases.
6. After three failed attempts, the system displays an intrusion alert and locks itself.
7. The user can view the security status or reset the system.

🚀 How to Run

1. Download or clone this repository.
2. Open the Assembly source file in EMU8086 or a compatible MASM environment.
3. Assemble and compile the program.
4. Run the generated executable.
5. Use the main menu to explore the system features.

⚠️ Disclaimer

This project is developed for educational purposes to demonstrate basic security concepts and Assembly Language programming. It is a simulated login security system, not a production-level intrusion detection solution.
