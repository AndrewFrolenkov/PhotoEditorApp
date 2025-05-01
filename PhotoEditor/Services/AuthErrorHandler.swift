//
//  AuthErrorHandler.swift
//  PhotoEditor
//
//  Created by Андрей Фроленков on 1.05.25.
//

import Foundation
import FirebaseAuth

class AuthErrorHandler {
    
    // Метод для обработки ошибок при регистрации
    func handleSignUpError(_ error: Error) -> String {
        switch error {
        case let authError as NSError:
            switch authError.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                return "Этот email уже используется. Пожалуйста, выберите другой."
            case AuthErrorCode.invalidEmail.rawValue:
                return "Неверный формат email."
            case AuthErrorCode.weakPassword.rawValue:
                return "Пароль слишком слабый. Используйте более сложный пароль."
            default:
                return "Ошибка регистрации: \(authError.localizedDescription)"
            }
        default:
            return "Ошибка регистрации: \(error.localizedDescription)"
        }
    }
    
    // Метод для обработки ошибок при входе
    func handleSignInError(_ error: Error) -> String {
        switch error {
        case let authError as NSError:
            switch authError.code {
            case AuthErrorCode.userNotFound.rawValue:
                return "Пользователь с таким email не найден."
            case AuthErrorCode.wrongPassword.rawValue:
                return "Неверный пароль. Пожалуйста, попробуйте снова."
            case AuthErrorCode.invalidEmail.rawValue:
                return "Неверный формат email."
            case AuthErrorCode.networkError.rawValue:
                return "Ошибка сети. Проверьте соединение и попробуйте снова."
            default:
                return "Ошибка входа: \(error.localizedDescription)"
            }
        default:
            return "Ошибка входа: \(error.localizedDescription)"
        }
    }
    
    // Метод для обработки ошибок при сбросе пароля
    func handlePasswordResetError(_ error: Error) -> String {
        switch error {
        case let authError as NSError :
            switch authError.code {
            case AuthErrorCode.userNotFound.rawValue:
                return "Пользователь с таким email не найден."
            case AuthErrorCode.invalidEmail.rawValue:
                return "Неверный формат email."
            default:
                return "Ошибка при сбросе пароля: \(authError.localizedDescription)"
            }
        default:
            return "Ошибка при сбросе пароля: \(error.localizedDescription)"
        }
    }
}
