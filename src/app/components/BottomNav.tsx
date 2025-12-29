import { Home, Search, Calendar, MessageCircle, User, Package, Plus, Star } from 'lucide-react';
import { useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import { useTheme } from '../contexts/ThemeContext';

interface BottomNavProps {
  active?: 'home' | 'search' | 'bookings' | 'messages' | 'profile' | 'dashboard' | 'trips' | 'create' | 'reviews';
}

export default function BottomNav({ active = 'home' }: BottomNavProps) {
  const navigate = useNavigate();
  const location = useLocation();
  const { user } = useAuth();
  const { darkMode } = useTheme();

  // Navigation items for clients
  const clientNavItems = [
    { id: 'home', label: 'Home', icon: Home, path: '/home' },
    { id: 'search', label: 'Search', icon: Search, path: '/search' },
    { id: 'bookings', label: 'Bookings', icon: Calendar, path: '/my-bookings' },
    { id: 'messages', label: 'Messages', icon: MessageCircle, path: '/messages' },
    { id: 'profile', label: 'Profile', icon: User, path: '/profile' },
  ];

  // Navigation items for transporters
  const transporterNavItems = [
    { id: 'dashboard', label: 'Dashboard', icon: Home, path: '/transporter-dashboard' },
    { id: 'trips', label: 'Trips', icon: Package, path: '/my-trips' },
    { id: 'create', label: 'Create', icon: Plus, path: '/create-trip' },
    { id: 'messages', label: 'Messages', icon: MessageCircle, path: '/messages' },
    { id: 'profile', label: 'Profile', icon: User, path: '/transporter-profile' },
  ];

  const navItems = user?.type === 'transporter' ? transporterNavItems : clientNavItems;

  return (
    <div className={`fixed bottom-0 left-0 right-0 border-t safe-area-bottom max-w-[390px] mx-auto transition-colors ${
      darkMode 
        ? 'bg-gray-800 border-gray-700' 
        : 'bg-white border-gray-200'
    }`}>
      <div className="flex justify-around items-center py-2">
        {navItems.map((item) => {
          const Icon = item.icon;
          const isActive = active === item.id;
          return (
            <button
              key={item.id}
              onClick={() => navigate(item.path)}
              className="flex flex-col items-center justify-center flex-1 py-2 transition-colors"
            >
              <Icon 
                className={`w-6 h-6 mb-1 transition-colors ${
                  isActive 
                    ? user?.type === 'transporter' 
                      ? 'text-[#FF9500]' 
                      : 'text-[#0066FF]'
                    : darkMode 
                      ? 'text-gray-500' 
                      : 'text-gray-400'
                }`}
              />
              <span className={`text-xs transition-colors ${
                isActive 
                  ? user?.type === 'transporter' 
                    ? 'text-[#FF9500]' 
                    : 'text-[#0066FF]'
                  : darkMode 
                    ? 'text-gray-400' 
                    : 'text-gray-600'
              }`}>
                {item.label}
              </span>
            </button>
          );
        })}
      </div>
    </div>
  );
}
