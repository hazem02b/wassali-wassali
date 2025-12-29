import { LucideIcon } from 'lucide-react';
import { useTheme } from '../contexts/ThemeContext';

interface EmptyStateProps {
  icon: LucideIcon;
  title: string;
  description?: string;
  action?: {
    label: string;
    onClick: () => void;
  };
}

export default function EmptyState({ icon: Icon, title, description, action }: EmptyStateProps) {
  const { darkMode } = useTheme();

  return (
    <div className={`flex flex-col items-center justify-center py-16 px-4 ${
      darkMode ? 'text-gray-400' : 'text-gray-500'
    }`}>
      <Icon className={`w-16 h-16 mb-4 ${
        darkMode ? 'text-gray-600' : 'text-gray-300'
      }`} />
      <h3 className={`text-lg font-medium mb-2 ${
        darkMode ? 'text-gray-300' : 'text-gray-700'
      }`}>{title}</h3>
      {description && (
        <p className={`text-sm text-center max-w-sm ${
          darkMode ? 'text-gray-500' : 'text-gray-400'
        }`}>{description}</p>
      )}
      {action && (
        <button
          onClick={action.onClick}
          className="mt-6 px-6 py-2 bg-[#0066FF] text-white rounded-lg hover:bg-[#0052CC] transition-colors"
        >
          {action.label}
        </button>
      )}
    </div>
  );
}
