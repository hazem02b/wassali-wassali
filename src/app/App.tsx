import { BrowserRouter, Routes, Route } from 'react-router-dom';
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
import TransporterDashboard from './pages/TransporterDashboard';
import CreateTrip from './pages/CreateTrip';
import MyTrips from './pages/MyTrips';
import TransporterReviews from './pages/TransporterReviews';

export default function App() {
  return (
    <BrowserRouter>
      <div className="app-container max-w-[390px] mx-auto min-h-screen bg-gray-50">
        <Routes>
          <Route path="/" element={<LandingPage />} />
          <Route path="/signup-client" element={<SignupClient />} />
          <Route path="/signup-transporter" element={<SignupTransporter />} />
          <Route path="/login" element={<LoginPage />} />
          <Route path="/home" element={<HomeClient />} />
          <Route path="/search" element={<SearchResults />} />
          <Route path="/transport/:id" element={<TransportDetails />} />
          <Route path="/booking/:id" element={<BookingForm />} />
          <Route path="/payment" element={<PaymentPage />} />
          <Route path="/booking-confirmation" element={<BookingConfirmation />} />
          <Route path="/my-bookings" element={<MyBookings />} />
          <Route path="/profile" element={<ClientProfile />} />
          <Route path="/transporter-dashboard" element={<TransporterDashboard />} />
          <Route path="/create-trip" element={<CreateTrip />} />
          <Route path="/my-trips" element={<MyTrips />} />
          <Route path="/transporter-reviews" element={<TransporterReviews />} />
        </Routes>
      </div>
    </BrowserRouter>
  );
}
