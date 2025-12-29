import { User } from '../types';

interface UserAvatarProps {
  user?: User | null;
  size?: 'sm' | 'md' | 'lg' | 'xl';
  className?: string;
}

export default function UserAvatar({ user, size = 'md', className = '' }: UserAvatarProps) {
  const sizeClasses = {
    sm: 'w-8 h-8 text-sm',
    md: 'w-12 h-12 text-xl',
    lg: 'w-20 h-20 text-3xl',
    xl: 'w-24 h-24 text-4xl',
  };

  // Vérifier d'abord user.avatar, sinon localStorage avec l'ID utilisateur
  const avatarKey = user?.id ? `userAvatar_${user.id}` : 'userAvatar';
  const avatarUrl = user?.avatar || localStorage.getItem(avatarKey);

  return (
    <div className={`${sizeClasses[size]} rounded-full overflow-hidden flex items-center justify-center bg-white/20 ${className}`}>
      {avatarUrl ? (
        <img 
          src={avatarUrl} 
          alt={user?.name || 'User'} 
          className="w-full h-full object-cover"
        />
      ) : (
        <span>👤</span>
      )}
    </div>
  );
}
