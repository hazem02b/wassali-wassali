import { useNavigate } from 'react-router-dom';
import { CheckCircle, Download, Phone, MessageCircle, MapPin } from 'lucide-react';
import BottomNav from '../components/BottomNav';

export default function BookingConfirmation() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      {/* Success Animation */}
      <div className="bg-gradient-to-b from-green-50 to-white p-8 text-center">
        <div className="w-24 h-24 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
          <CheckCircle className="w-16 h-16 text-green-500" />
        </div>
        <h1 className="text-2xl mb-2">Booking Confirmed!</h1>
        <p className="text-gray-600">Your package is ready to be sent</p>
        <p className="text-sm text-gray-500 mt-2">Booking ID: #WAS12345</p>
      </div>

      {/* Booking Details */}
      <div className="px-6 space-y-4">
        <div className="bg-white rounded-xl p-4 border border-gray-200">
          <h2 className="mb-3">Trip Details</h2>
          <div className="space-y-2 text-sm">
            <div className="flex justify-between">
              <span className="text-gray-600">Route</span>
              <span>Tunis → Paris</span>
            </div>
            <div className="flex justify-between">
              <span className="text-gray-600">Date</span>
              <span>Dec 25, 2024</span>
            </div>
            <div className="flex justify-between">
              <span className="text-gray-600">Transporter</span>
              <span>Mohamed Ali</span>
            </div>
            <div className="flex justify-between">
              <span className="text-gray-600">Weight</span>
              <span>5 kg</span>
            </div>
            <div className="border-t border-gray-200 pt-2 mt-2"></div>
            <div className="flex justify-between text-lg">
              <span>Total Paid</span>
              <span className="text-green-600">240€</span>
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
          <button className="w-full flex items-center justify-center space-x-2 bg-white border border-gray-300 text-gray-700 py-4 rounded-xl">
            <Download className="w-5 h-5" />
            <span>Download Receipt</span>
          </button>
          <button
            onClick={() => navigate('/my-bookings')}
            className="w-full bg-[#0066FF] text-white py-4 rounded-xl transition-all active:scale-98"
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
