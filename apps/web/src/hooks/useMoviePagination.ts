import { useState } from 'react';

export function useMoviePagination(initialPage: number = 1) {
  const [currentPage, setCurrentPage] = useState(initialPage);
  const [totalPages, setTotalPages] = useState(1);

  const nextPage = () => {
    if (currentPage < totalPages) setCurrentPage((p) => p + 1);
  };

  const prevPage = () => {
    if (currentPage > 1) setCurrentPage((p) => p - 1);
  };

  const goToPage = (page: number) => {
    if (page >= 1 && page <= totalPages) setCurrentPage(page);
  };

  return {
    currentPage,
    totalPages,
    setTotalPages,
    nextPage,
    prevPage,
    goToPage,
  };
}
