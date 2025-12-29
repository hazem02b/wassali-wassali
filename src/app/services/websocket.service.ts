/**
 * Service WebSocket pour les notifications en temps réel
 */

export interface Notification {
  type: string;
  title: string;
  message: string;
  data: any;
  timestamp: string;
}

type NotificationCallback = (notification: Notification) => void;

class WebSocketService {
  private ws: WebSocket | null = null;
  private callbacks: Set<NotificationCallback> = new Set();
  private reconnectAttempts = 0;
  private maxReconnectAttempts = 5;
  private reconnectDelay = 3000;
  private token: string | null = null;

  /**
   * Connecter au WebSocket
   */
  connect(token: string) {
    this.token = token;
    const wsUrl = `ws://localhost:8000/api/v1/ws/notifications?token=${token}`;

    try {
      this.ws = new WebSocket(wsUrl);

      this.ws.onopen = () => {
        console.log('✅ WebSocket connecté');
        this.reconnectAttempts = 0;
        
        // Envoyer un ping toutes les 30 secondes pour garder la connexion
        setInterval(() => {
          if (this.ws?.readyState === WebSocket.OPEN) {
            this.ws.send('ping');
          }
        }, 30000);
      };

      this.ws.onmessage = (event) => {
        try {
          const notification: Notification = JSON.parse(event.data);
          console.log('📨 Notification reçue:', notification);
          
          // Notifier tous les callbacks
          this.callbacks.forEach(callback => callback(notification));
        } catch (error) {
          console.error('Erreur parsing notification:', error);
        }
      };

      this.ws.onerror = (error) => {
        console.error('❌ WebSocket erreur:', error);
      };

      this.ws.onclose = () => {
        console.log('🔌 WebSocket déconnecté');
        this.attemptReconnect();
      };

    } catch (error) {
      console.error('Erreur connexion WebSocket:', error);
      this.attemptReconnect();
    }
  }

  /**
   * Tentative de reconnexion
   */
  private attemptReconnect() {
    if (this.reconnectAttempts < this.maxReconnectAttempts && this.token) {
      this.reconnectAttempts++;
      console.log(`🔄 Reconnexion (${this.reconnectAttempts}/${this.maxReconnectAttempts})...`);
      
      setTimeout(() => {
        this.connect(this.token!);
      }, this.reconnectDelay);
    }
  }

  /**
   * S'abonner aux notifications
   */
  subscribe(callback: NotificationCallback) {
    this.callbacks.add(callback);
    
    return () => {
      this.callbacks.delete(callback);
    };
  }

  /**
   * Déconnecter
   */
  disconnect() {
    if (this.ws) {
      this.ws.close();
      this.ws = null;
    }
    this.callbacks.clear();
    this.token = null;
  }

  /**
   * Vérifier si connecté
   */
  isConnected(): boolean {
    return this.ws?.readyState === WebSocket.OPEN;
  }
}

// Export singleton
export const websocketService = new WebSocketService();
