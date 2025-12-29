// Types globaux pour l'application

export interface User {
  id: string;
  name: string;
  email: string;
  phone: string;
  type: 'client' | 'transporter';
  avatar?: string;
  rating?: number;
  verified?: boolean;
  totalBookings?: number;
  totalSpent?: number;
  joinedAt?: string;
  address?: string;
}

export interface Transporter extends User {
  type: 'transporter';
  rating: number;
  reviews: number;
  verified: boolean;
  totalTrips?: number;
  completedTrips?: number;
  monthlyRevenue?: number;
}

export interface Client extends User {
  type: 'client';
  savedAddresses?: Address[];
  paymentMethods?: PaymentMethod[];
}

export interface Address {
  id: string;
  label: string;
  street: string;
  city: string;
  postalCode: string;
  country: string;
  isDefault?: boolean;
}

export interface PaymentMethod {
  id: string;
  type: 'card' | 'wallet' | 'bank';
  last4?: string;
  expiryDate?: string;
  isDefault?: boolean;
}

export interface Trip {
  id: string;
  transporterId: string;
  transporterName: string;
  transporterAvatar?: string;
  transporterRating?: number;
  transporterVerified?: boolean;
  from: string;
  to: string;
  date: string;
  time: string;
  pricePerKg: number;
  totalCapacity: number;
  availableCapacity: number;
  capacityPercentage: number;
  transportableItems: string[];
  specialNotes?: string;
  isNegotiable?: boolean;
  hasInsurance?: boolean;
  status: 'active' | 'completed' | 'cancelled';
  createdAt: string;
}

export interface Booking {
  id: string;
  tripId: string;
  clientId: string;
  clientName: string;
  transporterId: string;
  transporterName: string;
  from: string;
  to: string;
  date: string;
  time: string;
  weight: number;
  pricePerKg: number;
  serviceFee: number;
  totalPrice: number;
  status: 'pending' | 'confirmed' | 'in-transit' | 'delivered' | 'cancelled';
  packageDescription: string;
  packagePhoto?: string;
  pickupAddress: string;
  deliveryAddress: string;
  specialNotes?: string;
  paymentMethod: string;
  paymentStatus: 'pending' | 'completed' | 'refunded';
  createdAt: string;
  updatedAt: string;
}

export interface Review {
  id: string;
  bookingId: string;
  transporterId: string;
  clientId: string;
  clientName: string;
  rating: 1 | 2 | 3 | 4 | 5;
  comment: string;
  createdAt: string;
}

export interface Notification {
  id: string;
  userId: string;
  title: string;
  message: string;
  type: 'success' | 'error' | 'info' | 'warning';
  category: 'booking' | 'message' | 'payment' | 'system';
  relatedId?: string;
  read: boolean;
  timestamp: string;
}

export interface Message {
  id: string;
  conversationId: string;
  senderId: string;
  receiverId: string;
  text: string;
  attachments?: string[];
  read: boolean;
  timestamp: string;
}

export interface Conversation {
  id: string;
  participants: User[];
  lastMessage: Message;
  unreadCount: number;
  updatedAt: string;
}

export interface SearchFilters {
  from?: string;
  to?: string;
  date?: string;
  minWeight?: number;
  maxWeight?: number;
  minPrice?: number;
  maxPrice?: number;
  verifiedOnly?: boolean;
  hasInsurance?: boolean;
}

export interface Statistics {
  totalTrips: number;
  activeTrips: number;
  completedTrips: number;
  totalBookings: number;
  pendingBookings: number;
  totalRevenue: number;
  monthlyRevenue: number;
  averageRating: number;
  totalReviews: number;
}

// Type guards
export const isTransporter = (user: User): user is Transporter => {
  return user.type === 'transporter';
};

export const isClient = (user: User): user is Client => {
  return user.type === 'client';
};

// Utility types
export type BookingStatus = Booking['status'];
export type TripStatus = Trip['status'];
export type NotificationType = Notification['type'];
export type PaymentMethodType = PaymentMethod['type'];

// API Response types
export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
}

export interface PaginatedResponse<T> {
  items: T[];
  total: number;
  page: number;
  pageSize: number;
  hasMore: boolean;
}
