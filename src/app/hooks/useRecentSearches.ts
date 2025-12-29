import { useState, useEffect } from 'react';
import { STORAGE_KEYS } from '../constants';

export interface RecentSearch {
  id: string;
  from: string;
  to: string;
  date: string;
  timestamp: number;
}

const MAX_RECENT_SEARCHES = 5;

export function useRecentSearches() {
  const [recentSearches, setRecentSearches] = useState<RecentSearch[]>([]);

  // Load recent searches from localStorage on mount
  useEffect(() => {
    try {
      const stored = localStorage.getItem(STORAGE_KEYS.RECENT_SEARCHES);
      if (stored) {
        const searches = JSON.parse(stored) as RecentSearch[];
        setRecentSearches(searches);
      }
    } catch (error) {
      console.error('Error loading recent searches:', error);
    }
  }, []);

  // Add a new search to recent searches
  const addRecentSearch = (from: string, to: string) => {
    if (!from || !to) return;

    const newSearch: RecentSearch = {
      id: `${Date.now()}-${Math.random()}`,
      from: from.trim(),
      to: to.trim(),
      date: formatDate(new Date()),
      timestamp: Date.now(),
    };

    setRecentSearches((prev) => {
      // Remove duplicate searches (same from and to)
      const filtered = prev.filter(
        (search) => !(search.from === newSearch.from && search.to === newSearch.to)
      );

      // Add new search at the beginning
      const updated = [newSearch, ...filtered].slice(0, MAX_RECENT_SEARCHES);

      // Save to localStorage
      try {
        localStorage.setItem(STORAGE_KEYS.RECENT_SEARCHES, JSON.stringify(updated));
      } catch (error) {
        console.error('Error saving recent searches:', error);
      }

      return updated;
    });
  };

  // Clear all recent searches
  const clearRecentSearches = () => {
    setRecentSearches([]);
    try {
      localStorage.removeItem(STORAGE_KEYS.RECENT_SEARCHES);
    } catch (error) {
      console.error('Error clearing recent searches:', error);
    }
  };

  // Remove a specific search
  const removeRecentSearch = (id: string) => {
    setRecentSearches((prev) => {
      const updated = prev.filter((search) => search.id !== id);
      try {
        localStorage.setItem(STORAGE_KEYS.RECENT_SEARCHES, JSON.stringify(updated));
      } catch (error) {
        console.error('Error removing recent search:', error);
      }
      return updated;
    });
  };

  return {
    recentSearches,
    addRecentSearch,
    clearRecentSearches,
    removeRecentSearch,
  };
}

// Helper function to format date
function formatDate(date: Date): string {
  const today = new Date();
  const yesterday = new Date(today);
  yesterday.setDate(yesterday.getDate() - 1);

  if (isSameDay(date, today)) {
    return "Aujourd'hui";
  } else if (isSameDay(date, yesterday)) {
    return 'Hier';
  } else {
    const months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
    return `${months[date.getMonth()]} ${date.getDate()}`;
  }
}

function isSameDay(date1: Date, date2: Date): boolean {
  return (
    date1.getFullYear() === date2.getFullYear() &&
    date1.getMonth() === date2.getMonth() &&
    date1.getDate() === date2.getDate()
  );
}
