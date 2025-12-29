import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { AuthProvider } from './contexts/AuthContext';
import { ThemeProvider } from './contexts/ThemeContext';
import { LanguageProvider } from './contexts/LanguageContext';
import { BookingProvider } from './contexts/BookingContext';
import { NotificationProvider } from './contexts/NotificationContext';
import { TripsProvider } from './contexts/TripsContext';
import NotificationToast from './components/NotificationToast';
import ProtectedRoute from './components/ProtectedRoute';
import LandingPage from './pages/LandingPage';
import SignupClient from './pages/SignupClient';
import SignupTransporter from './pages/SignupTransporter';
import LoginPage from './pages/LoginPage';
import HomeClient from './pages/HomeClient';
import SearchResults from './pages/SearchResults';
import TransportDetails from './pages/TransportDetails';
import BookingForm from './pages/BookingForm';
import PaymentPage from './pages/PaymentPage';
import BookingConfirmation from './pages/BookingConfirmation';
import MyBookings from './pages/MyBookings';
import ClientProfile from './pages/ClientProfile';
import EditProfile from './pages/EditProfile';
import SettingsPage from './pages/SettingsPage';
import ChangePasswordPage from './pages/ChangePasswordPage';
import PaymentMethodsPage from './pages/PaymentMethodsPage';
import HelpSupportPage from './pages/HelpSupportPage';
import TransporterDashboard from './pages/TransporterDashboard';
import CreateTrip from './pages/CreateTrip';
import MyTrips from './pages/MyTrips';
import MyReviews from './pages/MyReviews';
import LeaveReview from './pages/LeaveReview';
import TransporterReviews from './pages/TransporterReviews';
import TransporterProfile from './pages/TransporterProfile';
import TransporterHelpPage from './pages/TransporterHelpPage';
import MessagesPage from './pages/MessagesPage';
import ChatPage from './pages/ChatPage';
import ForgotPassword from './pages/ForgotPassword';
import ResetPassword from './pages/ResetPassword';

export default function App() {
  return (
    <ThemeProvider>
      <LanguageProvider>
        <AuthProvider>
          <TripsProvider>
            <BookingProvider>
              <NotificationProvider>
                <BrowserRouter>
            <div className="app-container max-w-[390px] mx-auto min-h-screen bg-gray-50">
              <NotificationToast />
              <Routes>
                <Route path="/" element={<LandingPage />} />
                <Route path="/signup-client" element={<SignupClient />} />
                <Route path="/signup-transporter" element={<SignupTransporter />} />
                <Route path="/login" element={<LoginPage />} />
                <Route path="/forgot-password" element={<ForgotPassword />} />
                <Route path="/reset-password" element={<ResetPassword />} />
                
                {/* Routes Client uniquement */}
                <Route path="/home" element={<ProtectedRoute allowedRole="client"><HomeClient /></ProtectedRoute>} />
                <Route path="/search" element={<ProtectedRoute allowedRole="client"><SearchResults /></ProtectedRoute>} />
                <Route path="/transport/:id" element={<ProtectedRoute allowedRole="client"><TransportDetails /></ProtectedRoute>} />
                <Route path="/booking/:id" element={<ProtectedRoute allowedRole="client"><BookingForm /></ProtectedRoute>} />
                <Route path="/payment" element={<ProtectedRoute allowedRole="client"><PaymentPage /></ProtectedRoute>} />
                <Route path="/booking-confirmation" element={<ProtectedRoute allowedRole="client"><BookingConfirmation /></ProtectedRoute>} />
                <Route path="/my-bookings" element={<ProtectedRoute allowedRole="client"><MyBookings /></ProtectedRoute>} />
                <Route path="/leave-review" element={<ProtectedRoute allowedRole="client"><LeaveReview /></ProtectedRoute>} />
                <Route path="/profile" element={<ProtectedRoute allowedRole="client"><ClientProfile /></ProtectedRoute>} />
                <Route path="/edit-profile" element={<ProtectedRoute><EditProfile /></ProtectedRoute>} />
                
                {/* Routes Transporteur uniquement */}
                <Route path="/transporter-dashboard" element={<ProtectedRoute allowedRole="transporter"><TransporterDashboard /></ProtectedRoute>} />
                <Route path="/create-trip" element={<ProtectedRoute allowedRole="transporter"><CreateTrip /></ProtectedRoute>} />
                <Route path="/edit-trip/:id" element={<ProtectedRoute allowedRole="transporter"><CreateTrip /></ProtectedRoute>} />
                <Route path="/my-trips" element={<ProtectedRoute allowedRole="transporter"><MyTrips /></ProtectedRoute>} />
                <Route path="/my-reviews" element={<ProtectedRoute allowedRole="transporter"><MyReviews /></ProtectedRoute>} />
                <Route path="/transporter-reviews" element={<ProtectedRoute allowedRole="transporter"><TransporterReviews /></ProtectedRoute>} />
                <Route path="/transporter-profile" element={<ProtectedRoute allowedRole="transporter"><TransporterProfile /></ProtectedRoute>} />
                <Route path="/help-transporter" element={<ProtectedRoute allowedRole="transporter"><TransporterHelpPage /></ProtectedRoute>} />
                
                {/* Routes communes (accessible par les deux) */}
                <Route path="/settings" element={<ProtectedRoute><SettingsPage /></ProtectedRoute>} />
                <Route path="/change-password" element={<ProtectedRoute><ChangePasswordPage /></ProtectedRoute>} />
                <Route path="/payment-methods" element={<ProtectedRoute><PaymentMethodsPage /></ProtectedRoute>} />
                <Route path="/help" element={<ProtectedRoute><HelpSupportPage /></ProtectedRoute>} />
                <Route path="/messages" element={<ProtectedRoute><MessagesPage /></ProtectedRoute>} />
                <Route path="/chat/:conversationId" element={<ProtectedRoute><ChatPage /></ProtectedRoute>} />
              </Routes>
            </div>
          </BrowserRouter>
        </NotificationProvider>
      </BookingProvider>
    </TripsProvider>
    </AuthProvider>
      </LanguageProvider>
    </ThemeProvider>
  );
}
