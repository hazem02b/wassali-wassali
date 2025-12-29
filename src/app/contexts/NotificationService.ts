/**
 * Service de gestion des notifications
 * Système complet pour afficher des notifications toast dans l'application
 */

export interface Notification {
  id: string;
  type: 'success' | 'error' | 'warning' | 'info';
  title: string;
  message: string;
  timestamp: Date;
  read: boolean;
  action?: {
    label: string;
    onClick: () => void;
  };
}

class NotificationServiceClass {
  private listeners: Set<(notifications: Notification[]) => void> = new Set();
  private notifications: Notification[] = [];

  constructor() {
    // Charger les notifications depuis localStorage au démarrage
    this.loadFromStorage();
  }

  /**
   * S'abonner aux changements de notifications
   */
  subscribe(callback: (notifications: Notification[]) => void) {
    this.listeners.add(callback);
    callback(this.notifications);
    
    return () => {
      this.listeners.delete(callback);
    };
  }

  /**
   * Notifier tous les abonnés
   */
  private notify() {
    this.listeners.forEach(callback => callback(this.notifications));
    this.saveToStorage();
  }

  /**
   * Ajouter une notification
   */
  add(notification: Omit<Notification, 'id' | 'timestamp' | 'read'>) {
    const newNotification: Notification = {
      ...notification,
      id: Date.now().toString() + Math.random(),
      timestamp: new Date(),
      read: false,
    };

    this.notifications = [newNotification, ...this.notifications];
    this.notify();

    // Auto-supprimer après 5 secondes pour les notifications non-action
    if (!notification.action) {
      setTimeout(() => {
        this.remove(newNotification.id);
      }, 5000);
    }

    return newNotification.id;
  }

  /**
   * Notifications rapides
   */
  success(title: string, message: string) {
    return this.add({ type: 'success', title, message });
  }

  error(title: string, message: string) {
    return this.add({ type: 'error', title, message });
  }

  warning(title: string, message: string) {
    return this.add({ type: 'warning', title, message });
  }

  info(title: string, message: string) {
    return this.add({ type: 'info', title, message });
  }

  /**
   * Marquer comme lu
   */
  markAsRead(id: string) {
    this.notifications = this.notifications.map(n =>
      n.id === id ? { ...n, read: true } : n
    );
    this.notify();
  }

  /**
   * Marquer tout comme lu
   */
  markAllAsRead() {
    this.notifications = this.notifications.map(n => ({ ...n, read: true }));
    this.notify();
  }

  /**
   * Supprimer une notification
   */
  remove(id: string) {
    this.notifications = this.notifications.filter(n => n.id !== id);
    this.notify();
  }

  /**
   * Supprimer toutes les notifications
   */
  clear() {
    this.notifications = [];
    this.notify();
  }

  /**
   * Obtenir le nombre de notifications non lues
   */
  getUnreadCount(): number {
    return this.notifications.filter(n => !n.read).length;
  }

  /**
   * Sauvegarder dans localStorage
   */
  private saveToStorage() {
    try {
      localStorage.setItem('notifications', JSON.stringify(this.notifications));
    } catch (error) {
      console.error('Erreur sauvegarde notifications:', error);
    }
  }

  /**
   * Charger depuis localStorage
   */
  private loadFromStorage() {
    try {
      const saved = localStorage.getItem('notifications');
      if (saved) {
        this.notifications = JSON.parse(saved).map((n: any) => ({
          ...n,
          timestamp: new Date(n.timestamp),
        }));
      }
    } catch (error) {
      console.error('Erreur chargement notifications:', error);
      this.notifications = [];
    }
  }
}

// Export singleton
export const NotificationService = new NotificationServiceClass();
