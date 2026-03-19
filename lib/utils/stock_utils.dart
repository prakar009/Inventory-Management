String getStockStatus(int stock) {
  if (stock == 0) return "Out of Stock";
  if (stock < 10) return "Low Stock";
  return "In Stock";
}