/**
 * Service API pour les requêtes vers le backend Wassali
 */
import API_CONFIG from '../config/api.config';

class APIService {
  private baseURL: string;
  
  constructor() {
    this.baseURL = API_CONFIG.BASE_URL;
  }
  
  /**
   * Effectue une requête HTTP
   */
  private async request<T>(
    endpoint: string,
    options: RequestInit = {}
  ): Promise<T> {
    const url = `${this.baseURL}${endpoint}`;
    
    console.log('API Request:', {
      url,
      method: options.method,
      headers: options.headers,
    });
    
    const response = await fetch(url, {
      ...options,
      headers: {
        ...API_CONFIG.getHeaders(),
        ...options.headers,
      },
    });
    
    console.log('API Response:', {
      status: response.status,
      ok: response.ok,
    });
    
    if (!response.ok) {
      const error = await response.json().catch(() => ({
        detail: 'Une erreur est survenue',
      }));
      console.error('API Error:', error);
      throw new Error(error.detail || `HTTP ${response.status}`);
    }
    
    // Gérer les réponses vides (DELETE, etc.)
    const contentType = response.headers.get('content-type');
    if (!contentType || !contentType.includes('application/json')) {
      return null as T;
    }
    
    const text = await response.text();
    if (!text) {
      return null as T;
    }
    
    return JSON.parse(text) as T;
  }
  
  /**
   * Requête GET
   */
  async get<T>(endpoint: string, token?: string): Promise<T> {
    return this.request<T>(endpoint, {
      method: 'GET',
      headers: token ? API_CONFIG.getHeaders(token) : undefined,
    });
  }
  
  /**
   * Requête POST
   */
  async post<T>(endpoint: string, data: any, token?: string): Promise<T> {
    return this.request<T>(endpoint, {
      method: 'POST',
      headers: token ? API_CONFIG.getHeaders(token) : undefined,
      body: JSON.stringify(data),
    });
  }
  
  /**
   * Requête PUT
   */
  async put<T>(endpoint: string, data: any, token?: string): Promise<T> {
    return this.request<T>(endpoint, {
      method: 'PUT',
      headers: token ? API_CONFIG.getHeaders(token) : undefined,
      body: JSON.stringify(data),
    });
  }
  
  /**
   * Requête DELETE
   */
  async delete<T>(endpoint: string, token?: string): Promise<T> {
    return this.request<T>(endpoint, {
      method: 'DELETE',
      headers: token ? API_CONFIG.getHeaders(token) : undefined,
    });
  }
  
  // ==================== AUTH ====================
  
  async register(userData: {
    email: string;
    password: string;
    name: string;
    phone: string;
    role: 'client' | 'transporter';
  }) {
    // Utiliser les endpoints spécifiques selon le rôle
    const endpoint = userData.role === 'client' 
      ? API_CONFIG.ENDPOINTS.REGISTER_CLIENT 
      : API_CONFIG.ENDPOINTS.REGISTER_TRANSPORTER;
    
    return this.post(endpoint, userData);
  }
  
  async login(email: string, password: string, role: 'client' | 'transporter') {
    // Envoyer role pour différencier les comptes
    return this.post(API_CONFIG.ENDPOINTS.LOGIN, {
      email,
      password,
      role
    });
  }
  
  async getProfile(token: string) {
    return this.get(API_CONFIG.ENDPOINTS.PROFILE, token);
  }
  
  async updateProfile(data: any, token: string) {
    return this.put(API_CONFIG.ENDPOINTS.PROFILE, data, token);
  }

  async changePassword(token: string, data: { current_password: string; new_password: string }) {
    return this.put(`${API_CONFIG.ENDPOINTS.AUTH}/change-password`, data, token);
  }
  
  async forgotPassword(email: string, role: 'client' | 'transporter') {
    return this.post('/auth/forgot-password', { email, role });
  }
  
  async resetPassword(email: string, role: 'client' | 'transporter', reset_code: string, new_password: string) {
    return this.post('/auth/reset-password', { email, role, reset_code, new_password });
  }
  
  // ==================== TRIPS ====================
  
  async getTrips(token?: string) {
    return this.get(API_CONFIG.ENDPOINTS.TRIPS, token);
  }
  
  async searchTrips(params: {
    origin_city?: string;
    destination_city?: string;
    departure_date?: string;
    min_weight?: number;
  }, token?: string) {
    const queryString = new URLSearchParams(params as any).toString();
    return this.get(`${API_CONFIG.ENDPOINTS.TRIPS_SEARCH}?${queryString}`, token);
  }
  
  async createTrip(tripData: any, token: string) {
    return this.post(API_CONFIG.ENDPOINTS.TRIPS, tripData, token);
  }
  
  async getMyTrips(token: string) {
    return this.get(API_CONFIG.ENDPOINTS.MY_TRIPS, token);
  }
  
  async getTripById(tripId: number) {
    return this.get(`${API_CONFIG.ENDPOINTS.TRIPS}/${tripId}`);
  }
  
  async updateTrip(tripId: number, tripData: any, token: string) {
    return this.put(`${API_CONFIG.ENDPOINTS.TRIPS}/${tripId}`, tripData, token);
  }
  
  async deleteTrip(tripId: number, token: string) {
    return this.delete(`${API_CONFIG.ENDPOINTS.TRIPS}/${tripId}`, token);
  }
  
  // ==================== BOOKINGS ====================
  
  async createBooking(bookingData: any, token: string) {
    return this.post(API_CONFIG.ENDPOINTS.BOOKINGS, bookingData, token);
  }
  
  async getMyBookings(token: string) {
    return this.get(API_CONFIG.ENDPOINTS.MY_BOOKINGS, token);
  }
  
  async updateBookingStatus(bookingId: number, status: string, token: string) {
    return this.put(`${API_CONFIG.ENDPOINTS.BOOKINGS}/${bookingId}`, { status }, token);
  }

  async updateBooking(bookingId: number, data: any, token: string) {
    return this.put(`${API_CONFIG.ENDPOINTS.BOOKINGS}/${bookingId}`, data, token);
  }

  // ==================== MESSAGES ====================
  
  async getConversations(token: string) {
    return this.get(API_CONFIG.ENDPOINTS.CONVERSATIONS, token);
  }
  
  async getConversationMessages(conversationId: string, token: string) {
    return this.get(API_CONFIG.ENDPOINTS.CONVERSATION_MESSAGES(conversationId), token);
  }
  
  async sendMessage(receiverId: number, content: string, token: string) {
    return this.post(API_CONFIG.ENDPOINTS.MESSAGES, { receiver_id: receiverId, content }, token);
  }
  
  async markMessageAsRead(messageId: number, token: string) {
    return this.put(API_CONFIG.ENDPOINTS.MARK_READ(messageId), {}, token);
  }

  // ==================== USERS ====================
  
  async getAvailableUsers(token: string) {
    return this.get('/users/available', token);
  }

  async getCurrentUser(token: string) {
    return this.get('/users/me', token);
  }

  async getUserStats(token: string) {
    return this.get('/users/me/stats', token);
  }

  async updateUserProfile(data: any, token: string) {
    return this.put('/users/me', data, token);
  }

  // ==================== REVIEWS ====================
  
  async createReview(reviewData: { booking_id: number; transporter_id: number; rating: number; comment?: string }, token: string) {
    return this.post(API_CONFIG.ENDPOINTS.REVIEWS, reviewData, token);
  }
  
  async getTransporterReviews(transporterId: number) {
    return this.get(`${API_CONFIG.ENDPOINTS.REVIEWS}/transporter/${transporterId}`);
  }
  
  async getMyReviews(token: string) {
    return this.get(`${API_CONFIG.ENDPOINTS.REVIEWS}/my-reviews`, token);
  }
  
  async getBookingReview(bookingId: number) {
    return this.get(`${API_CONFIG.ENDPOINTS.REVIEWS}/booking/${bookingId}`).catch(() => null);
  }
}

export const apiService = new APIService();
export default apiService;
