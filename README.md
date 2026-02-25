# OpenClaw Mac Control

Нативное macOS-приложение (SwiftUI) для:
- подключения к серверу OpenClaw,
- безопасного хранения OpenAI-профилей,
- быстрого восстановления нескольких OpenAI-аккаунтов.

## Что уже есть в MVP v1
- Вкладка **Server** (IP / login / password, UI-скелет)
- Вкладка **OpenAI**:
  - добавление и удаление профилей,
  - хранение метаданных локально,
  - хранение токенов в **macOS Keychain**
- Вкладка **Restore**:
  - пошаговый wizard по профилям,
  - сохранение токена в Keychain,
  - навигация назад/вперёд/пропуск

---

## Быстрый запуск на Mac (минимум действий)

### 1) Установить Xcode (если ещё не установлен)
App Store → Xcode → Install

### 2) Запустить приложение
В Terminal:

```bash
cd ~
git clone https://github.com/Trevare/openclaw-mac-control.git
cd openclaw-mac-control
./run-macos.sh
```

Если система спросит разрешение на запуск/доступ к Keychain — нажми **Allow**.

---

## Запуск через Xcode (если хочешь GUI-режим разработки)

```bash
cd ~/openclaw-mac-control
open Package.swift
```

Дальше в Xcode:
- выбрать схему `OpenClawControl`
- нажать **Run**

---

## Структура
- `Sources/OpenClawControl/` — рабочий SwiftUI MVP
- `docs/` — PRD, архитектура, roadmap
- `run-macos.sh` — быстрый запуск

## Безопасность
- Токены не пишутся в plain text-файлы.
- Секреты сохраняются в macOS Keychain.
