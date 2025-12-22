import { Home, Search, Calendar, User } from 'lucide-react';
import { useNavigate, useLocation } from 'react-router-dom';

interface BottomNavProps {
  active?: 'home' | 'search' | 'bookings' | 'profile';
}

export default function BottomNav({ active = 'home' }: BottomNavProps) {
  const navigate = useNavigate();
  const location = useLocation();

  const navItems = [
    { id: 'home', label: 'Home', icon: Home, path: '/home' },
    { id: 'search', label: 'Search', icon: Search, path: '/search' },
    { id: 'bookings', label: 'Bookings', icon: Calendar, path: '/my-bookings' },
    { id: 'profile', label: 'Profile', icon: User, path: '/profile' },
  ];

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 safe-area-bottom max-w-[390px] mx-auto">
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
                  isActive ? 'text-[#0066FF]' : 'text-gray-400'
                }`}
              />
              <span className={`text-xs transition-colors ${
                isActive ? 'text-[#0066FF]' : 'text-gray-600'
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
