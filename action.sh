#!/system/bin/sh

STATE_FILE="/data/local/tmp/sensor_privacy_state"

# Verifica se o serviço sensor_privacy está disponível
if ! service list | grep -q "sensor_privacy"; then
    echo "Sensor privacy não disponível"
    exit 1
fi

# Determina o código de transação pela versão do Android
ANDROID_VERSION=$(getprop ro.build.version.release)
case "$ANDROID_VERSION" in
    13|14|15|16) SERVICE_CODE=9 ;;
    12)          SERVICE_CODE=8 ;;
    10|11)       SERVICE_CODE=4 ;;
    *)
        echo "Versão do Android não reconhecida: $ANDROID_VERSION"
        exit 1
        ;;
esac

# Alterna estado
if [ -f "$STATE_FILE" ]; then
    service call sensor_privacy $SERVICE_CODE i32 0 > /dev/null 2>&1
    rm -f "$STATE_FILE"
    echo "Sensor privacy DESATIVADO"
else
    service call sensor_privacy $SERVICE_CODE i32 1 > /dev/null 2>&1
    echo "1" > "$STATE_FILE"
    echo "Sensor privacy ATIVADO"
fi
