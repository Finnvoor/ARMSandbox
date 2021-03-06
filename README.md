# ARMSandbox
The source code for "An ARM Simulator Application for Teaching Assembly Language", my B.A.I. Final Year Project in Computer Engineering at Trinity College Dublin.  The goal of this project was to create an iPad application with lessons for learning ARM assembly language.  The application contains a visual sandbox that can be interacted with using software interrupts and memory access.  The application is similar to [Swift Playgrounds](https://www.apple.com/swift/playgrounds/), and the sanbox involves performing actions on numbers similar to the game [Human Resource Machine](https://tomorrowcorporation.com/humanresourcemachine).

A [Swift Package](https://swift.org/package-manager/) was created containing the assembler and emulator code that can be found [here](https://github.com/Finnvoor/AsmEmu).  The assembler makes use of [Tree-sitter](https://tree-sitter.github.io/tree-sitter/) to parse ARM programs into a syntax tree.

A PDF of the final report can be found [here](https://github.com/Finnvoor/ARMSandbox/blob/main/An%20ARM%20Simulator%20Application%20for%20Teaching%20Assembly%20Language.pdf).

## Usage
- Clone or download the repository and open the `.xcodeproj` file in Xcode.  
- Build and run the application on a device or simulator.

## Abstract
Assembly language is used to teach computing concepts to students at a low level.  This project aimed to create a simulator application analogous to an interactive textbook that can be used to engage and teach ARM assembly language to students.  Taking into account current simulators and the existing research on motivation and engagement techniques, the application was designed to teach fundamental concepts using a visual sandbox that written programs interact with and control.  The application was implemented as a self-contained iPad application, requiring little effort to download and run for free from the Apple App Store.  This app enables students to learn fundamental computing concepts from included lessons and allows course instructors to develop custom lessons for use in an assembly language course.

## Screenshots
### Lesson View
![Lessons](https://user-images.githubusercontent.com/8284016/117579379-7fece700-b0ea-11eb-8bd2-dc00887e81aa.png)
### Main Editor and Sandbox
![View](https://user-images.githubusercontent.com/8284016/117579381-824f4100-b0ea-11eb-8aa9-8e56806316c8.png)

Notes: The appliation uses the Keystone framework for demonstration purposes.  Keystone was originally developed by Nguyen Anh Quynh et al. and is licensed under GPLv2. More information about contributors and license terms can be found in the files [`KS-AUTHORS.TXT`](https://github.com/Finnvoor/ARMSandbox/blob/main/ARMSandbox/KS-AUTHORS.TXT), [`KS-CREDITS.TXT`](https://github.com/Finnvoor/ARMSandbox/blob/main/ARMSandbox/KS-CREDITS.TXT), [`KS-COPYING`](https://github.com/Finnvoor/ARMSandbox/blob/main/ARMSandbox/KS-COPYING), and the Keystone engine [repository](https://github.com/keystone-engine/keystone).

Some assets used in this application are public domain licensed assets found on [Kenney.nl](https://kenney.nl)
