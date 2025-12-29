import { useState, useEffect } from 'react';
import { X, CheckCircle, AlertCircle, AlertTriangle, Info } from 'lucide-react';
import { NotificationService, Notification } from '../contexts/NotificationService';
import { useTheme } from '../contexts/ThemeContext';

export default function NotificationToast() {
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const { darkMode } = useTheme();

  useEffect(() => {
    const unsubscribe = NotificationService.subscribe(setNotifications);
    return unsubscribe;
  }, []);

  const getIcon = (type: Notification['type']) => {
    switch (type) {
      case 'success':
        return <CheckCircle className="w-5 h-5 text-green-500" />;
      case 'error':
        return <AlertCircle className="w-5 h-5 text-red-500" />;
      case 'warning':
        return <AlertTriangle className="w-5 h-5 text-yellow-500" />;
      case 'info':
        return <Info className="w-5 h-5 text-blue-500" />;
    }
  };

  const getBorderColor = (type: Notification['type']) => {
    switch (type) {
      case 'success':
        return 'border-green-500';
      case 'error':
        return 'border-red-500';
      case 'warning':
        return 'border-yellow-500';
      case 'info':
        return 'border-blue-500';
    }
  };

  return (
    <div className="fixed top-4 right-4 z-50 space-y-2 max-w-sm">
      {notifications.slice(0, 3).map((notification) => (
        <div
          key={notification.id}
          className={`flex items-start space-x-3 p-4 rounded-lg shadow-lg border-l-4 backdrop-blur-sm animate-slide-in-right ${
            getBorderColor(notification.type)
          } ${
            darkMode 
              ? 'bg-gray-800/95 text-white' 
              : 'bg-white/95 text-gray-900'
          }`}
        >
          <div className="flex-shrink-0 mt-0.5">
            {getIcon(notification.type)}
          </div>
          
          <div className="flex-1 min-w-0">
            <p className={`text-sm font-semibold ${
              darkMode ? 'text-white' : 'text-gray-900'
            }`}>
              {notification.title}
            </p>
            <p className={`text-xs mt-1 ${
              darkMode ? 'text-gray-300' : 'text-gray-600'
            }`}>
              {notification.message}
            </p>
            
            {notification.action && (
              <button
                onClick={notification.action.onClick}
                className="text-xs text-blue-500 hover:text-blue-600 font-medium mt-2"
              >
                {notification.action.label}
              </button>
            )}
          </div>
          
          <button
            onClick={() => NotificationService.remove(notification.id)}
            className={`flex-shrink-0 p-1 rounded-full transition-colors ${
              darkMode 
                ? 'hover:bg-gray-700' 
                : 'hover:bg-gray-100'
            }`}
          >
            <X className={`w-4 h-4 ${
              darkMode ? 'text-gray-400' : 'text-gray-500'
            }`} />
          </button>
        </div>
      ))}
    </div>
  );
}
