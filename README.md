# Secure Student Management System 🎓🛡️

A full-stack, highly secure student management application built with **Flutter** (Mobile/Frontend) and **ASP.NET Core Web API** (Backend). 
This project heavily emphasizes API security, JWT authentication, and Role-Based Access Control (RBAC).

## 🚀 Overview
This system is designed to manage users and students securely. It provides distinct interfaces and permissions for different roles (`Admin`, `Teacher`, `Student`) and features a robust backend architecture that logs security events and manages user sessions safely.

## 🛠️ Tech Stack
* **Frontend:** Flutter (Dart), BLoC/Cubit for State Management, Dio for networking, Flutter Secure Storage.
* **Backend:** C# ASP.NET Core Web API, SQL Server.
* **Security:** JWT (JSON Web Tokens), BCrypt for password hashing.

## ✨ Key Features
* **Advanced JWT Authentication:** Secure login system utilizing Access Tokens and Refresh Tokens.
* **Role-Based Authorization:** Claims-based access control restricting endpoints and UI elements based on user roles (Admin, Teacher, Student).
* **Audit Logging System:** A complete tracking system for security events (e.g., tracking failed login attempts, deactivated account access, and critical system modifications).
* **Account State Management:** Admins can instantly deactivate users (`IsActive = false`), automatically blocking their API access and login capabilities.
* **Modern UI/UX:** Clean, responsive, and professional user interfaces adhering to Material Design principles.
