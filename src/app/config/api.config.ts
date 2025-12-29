/**
 * Configuration de l'API pour l'application Wassali
 */

export const API_CONFIG = {
  // URL de base de l'API
  BASE_URL: import.meta.env.VITE_API_URL || 'http://localhost:8888/api/v1',
  
  // Timeout pour les requêtes (en millisecondes)
  TIMEOUT: 30000,
  
  // Endpoints
  ENDPOINTS: {
    // Authentication
    AUTH: '/auth',
    REGISTER: '/auth/register',
    REGISTER_CLIENT: '/auth/register/client',
    REGISTER_TRANSPORTER: '/auth/register/transporter',
    LOGIN: '/auth/login',
    PROFILE: '/auth/profile',
    
    // Trips
    TRIPS: '/trips',
    TRIPS_SEARCH: '/trips/search',
    MY_TRIPS: '/trips/my',
    
    // Bookings
    BOOKINGS: '/bookings',
    MY_BOOKINGS: '/bookings/my',
    
    // Messages
    MESSAGES: '/messages',
    CONVERSATIONS: '/messages/conversations',
    CONVERSATION_MESSAGES: (conversationId: string) => `/messages/${conversationId}`,
    MARK_READ: (messageId: number) => `/messages/${messageId}/read`,
    
    // Reviews
    REVIEWS: '/reviews',
    
    // Notifications
    NOTIFICATIONS: '/notifications',
  },
  
  // Headers par défaut
  getHeaders: (token?: string) => {
    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
    };
    
    if (token) {
      headers['Authorization'] = `Bearer ${token}`;
    }
    
    return headers;
  },
};

export default API_CONFIG;
