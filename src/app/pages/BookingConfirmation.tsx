import { useNavigate, useLocation } from 'react-router-dom';
import { CheckCircle, Download, Phone, MessageCircle, MapPin } from 'lucide-react';
import BottomNav from '../components/BottomNav';

interface ConfirmationState {
  bookingId: number;
  trackingNumber: string;
  totalPrice: number;
  tripDetails: {
    origin: string;
    destination: string;
  };
  paymentMethod: string;
  paymentStatus: string;
}

export default function BookingConfirmation() {
  const navigate = useNavigate();
  const location = useLocation();
  const state = location.state as ConfirmationState | null;

  if (!state) {
    navigate('/my-bookings');
    return null;
  }

  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      {/* Success Animation */}
      <div className="bg-gradient-to-b from-green-50 to-white p-8 text-center">
        <div className="w-24 h-24 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
          <CheckCircle className="w-16 h-16 text-green-500" />
        </div>
        <h1 className="text-2xl mb-2">Booking Confirmed!</h1>
        <p className="text-gray-600">Your package is ready to be sent</p>
        <p className="text-sm text-gray-500 mt-2">Tracking: {state.trackingNumber}</p>
      </div>

      {/* Booking Details */}
      <div className="px-6 space-y-4">
        <div className="bg-white rounded-xl p-4 border border-gray-200">
          <h2 className="mb-3">Trip Details</h2>
          <div className="space-y-2 text-sm">
            <div className="flex justify-between">
              <span className="text-gray-600">Route</span>
              <span>{state.tripDetails.origin} → {state.tripDetails.destination}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-gray-600">Booking ID</span>
              <span>#{state.bookingId}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-gray-600">Payment Method</span>
              <span className="capitalize">{state.paymentMethod}</span>
            </div>
            <div className="border-t border-gray-200 pt-2 mt-2"></div>
            <div className="flex justify-between text-lg">
              <span>Total {state.paymentMethod === 'cash' ? 'Due' : 'Paid'}</span>
              <span className={state.paymentMethod === 'cash' ? 'text-orange-600' : 'text-green-600'}>
                {state.totalPrice.toFixed(2)}€
              </span>
            </div>
          </div>
        </div>

        {/* Quick Actions */}
        <div className="bg-white rounded-xl p-4 border border-gray-200">
          <h3 className="mb-3">Quick Actions</h3>
          <div className="grid grid-cols-3 gap-3">
            <button className="flex flex-col items-center p-3 bg-blue-50 rounded-xl">
              <Phone className="w-6 h-6 text-[#0066FF] mb-2" />
              <span className="text-xs">Call</span>
            </button>
            <button className="flex flex-col items-center p-3 bg-blue-50 rounded-xl">
              <MessageCircle className="w-6 h-6 text-[#0066FF] mb-2" />
              <span className="text-xs">Message</span>
            </button>
            <button className="flex flex-col items-center p-3 bg-blue-50 rounded-xl">
              <MapPin className="w-6 h-6 text-[#0066FF] mb-2" />
              <span className="text-xs">Track</span>
            </button>
          </div>
        </div>

        {/* Main Actions */}
        <div className="space-y-3 pt-4">
          <button 
            onClick={() => navigate(`/tracking/${state.trackingNumber}`)}
            className="w-full flex items-center justify-center space-x-2 bg-[#0066FF] text-white py-4 rounded-xl"
          >
            <MapPin className="w-5 h-5" />
            <span>Track Package</span>
          </button>
          <button
            onClick={() => navigate('/my-bookings')}
            className="w-full flex items-center justify-center space-x-2 bg-white border border-gray-300 text-gray-700 py-4 rounded-xl"
          >
            Go to My Bookings
          </button>
          <button
            onClick={() => navigate('/home')}
            className="w-full bg-gray-100 text-gray-700 py-4 rounded-xl"
          >
            Back to Home
          </button>
        </div>
      </div>

      <BottomNav active="bookings" />
    </div>
  );
}
