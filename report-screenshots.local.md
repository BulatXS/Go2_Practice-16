# Что доскринить в отчет (ПЗ-15)

## 1) SSH и VPS
- [ ] Команда и успешный вход:
```bash
ssh -i ~/.ssh/pr15_vps root@89.22.236.121
```

## 2) Размещение и структура
- [ ] Каталог деплоя:
```bash
ls -la /opt/pr15/deploy
```

## 3) systemd unit
- [ ] Файл юнита:
```bash
cat /etc/systemd/system/pr15-stack.service
```

## 4) Статус сервиса
- [ ] Статус `active`:
```bash
systemctl status pr15-stack --no-pager
```

## 5) Логи
- [ ] Последние 30 строк:
```bash
journalctl -u pr15-stack -n 30 --no-pager
```

## 6) Контейнеры
- [ ] Все `pr15-*` контейнеры в `Up`:
```bash
docker ps
```

## 7) Health-check
- [ ] Команда и ответ `{"status":"ok"}`:
```bash
curl -k https://127.0.0.1:8443/health
```

## 8) CI/CD (желательно)
- [ ] Скрин успешного GitHub Actions workflow `Build and Deploy to VPS`.

## 9) Доп. проверка ручек (по желанию)
- [ ] Запуск локального smoke-файла:
```bash
./smoke-requests.local.sh
```
