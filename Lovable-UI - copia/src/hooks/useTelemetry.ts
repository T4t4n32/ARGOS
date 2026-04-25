import { useState, useEffect, useRef } from 'react';

export interface TelemetryData {
  t: number;      // Temperatura
  g: number;      // Gas (ADC)
  d: number;      // Distancia (mm)
  h?: number;     // Humedad (opcional)
  risk?: string;  // Nivel de riesgo evaluado (NORMAL, WARNING, CRITICAL)
  timestamp?: number;
  source?: string;
}

export const useTelemetry = (url: string = 'ws://localhost:8765') => {
  const [data, setData] = useState<TelemetryData | null>(null);
  const [isConnected, setIsConnected] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const ws = useRef<WebSocket | null>(null);

  useEffect(() => {
    let reconnectTimeout: NodeJS.Timeout;

    const connect = () => {
      try {
        ws.current = new WebSocket(url);

        ws.current.onopen = () => {
          setIsConnected(true);
          setError(null);
          console.log('[Telemetry] Conectado a la Estación Base');
        };

        ws.current.onmessage = (event) => {
          try {
            const parsed = JSON.parse(event.data);
            if (parsed.t !== undefined || parsed.g !== undefined) {
              setData(parsed);
            }
          } catch (e) {
            console.error('[Telemetry] Error parseando JSON', e);
          }
        };

        ws.current.onclose = () => {
          setIsConnected(false);
          console.log('[Telemetry] Desconectado. Reconectando en 3s...');
          reconnectTimeout = setTimeout(connect, 3000);
        };

        ws.current.onerror = (err) => {
          setError('Fallo de conexión');
          ws.current?.close();
        };
      } catch (err) {
        setError('Error inicializando WebSocket');
      }
    };

    connect();

    return () => {
      clearTimeout(reconnectTimeout);
      if (ws.current) {
        ws.current.close();
      }
    };
  }, [url]);

  return { data, isConnected, error };
};
