import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Edit, MapPin, CreditCard, Bell, Moon, HelpCircle, LogOut, Package, DollarSign } from 'lucide-react';
import BottomNav from '../components/BottomNav';

export default function ClientProfile() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      <div className="bg-gradient-to-r from-[#0066FF] to-[#0052CC] text-white p-6 rounded-b-3xl mb-6">
        <button onClick={() => navigate('/home')} className="mb-6 p-2 hover:bg-white/10 rounded-full inline-flex">
          <ArrowLeft className="w-6 h-6" />
        </button>
        
        <div className="flex items-center space-x-4 mb-6">
          <div className="w-20 h-20 bg-white/20 rounded-full flex items-center justify-center text-3xl">
            👤
          </div>
          <div className="flex-1">
            <h1 className="text-xl mb-1">Ahmed Ben Ali</h1>
            <p className="text-blue-100 text-sm">ahmed@example.com</p>
          </div>
          <button className="p-2 hover:bg-white/10 rounded-full">
            <Edit className="w-5 h-5" />
          </button>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div className="bg-white/10 backdrop-blur rounded-xl p-4">
            <div className="flex items-center space-x-2 mb-1">
              <Package className="w-4 h-4" />
              <span className="text-sm text-blue-100">Total Bookings</span>
            </div>
            <p className="text-2xl">24</p>
          </div>
          <div className="bg-white/10 backdrop-blur rounded-xl p-4">
            <div className="flex items-center space-x-2 mb-1">
              <DollarSign className="w-4 h-4" />
              <span className="text-sm text-blue-100">Total Spent</span>
            </div>
            <p className="text-2xl">3,840€</p>
          </div>
        </div>
      </div>

      <div className="px-6 space-y-4">
        {/* Saved Addresses */}
        <div className="bg-white rounded-xl p-4 border border-gray-200">
          <h2 className="mb-3">Saved Addresses</h2>
          <button className="w-full flex items-center space-x-3 p-3 bg-gray-50 rounded-lg">
            <MapPin className="w-5 h-5 text-gray-400" />
            <div className="flex-1 text-left">
              <p className="text-sm">Home - Tunis</p>
              <p className="text-xs text-gray-500">123 Ave Habib Bourguiba</p>
            </div>
          </button>
        </div>

        {/* Payment Methods */}
        <div className="bg-white rounded-xl p-4 border border-gray-200">
          <h2 className="mb-3">Payment Methods</h2>
          <button className="w-full flex items-center space-x-3 p-3 bg-gray-50 rounded-lg">
            <CreditCard className="w-5 h-5 text-gray-400" />
            <div className="flex-1 text-left">
              <p className="text-sm">•••• •••• •••• 4242</p>
              <p className="text-xs text-gray-500">Expires 12/25</p>
            </div>
          </button>
        </div>

        {/* Settings */}
        <div className="bg-white rounded-xl overflow-hidden border border-gray-200">
          <button className="w-full flex items-center space-x-3 p-4 hover:bg-gray-50 border-b border-gray-100">
            <Bell className="w-5 h-5 text-gray-600" />
            <span className="flex-1 text-left">Notifications</span>
            <div className="w-10 h-6 bg-[#0066FF] rounded-full flex items-center px-1">
              <div className="w-4 h-4 bg-white rounded-full ml-auto"></div>
            </div>
          </button>
          <button className="w-full flex items-center space-x-3 p-4 hover:bg-gray-50">
            <Moon className="w-5 h-5 text-gray-600" />
            <span className="flex-1 text-left">Dark Mode</span>
            <div className="w-10 h-6 bg-gray-300 rounded-full flex items-center px-1">
              <div className="w-4 h-4 bg-white rounded-full"></div>
            </div>
          </button>
        </div>

        {/* Actions */}
        <div className="space-y-2">
          <button className="w-full flex items-center space-x-3 p-4 bg-white rounded-xl border border-gray-200 hover:bg-gray-50">
            <HelpCircle className="w-5 h-5 text-gray-600" />
            <span className="flex-1 text-left">Help & Support</span>
          </button>
          <button className="w-full flex items-center space-x-3 p-4 bg-white rounded-xl border border-red-200 text-red-600 hover:bg-red-50">
            <LogOut className="w-5 h-5" />
            <span className="flex-1 text-left">Logout</span>
          </button>
        </div>
      </div>

      <BottomNav active="profile" />
    </div>
  );
}
