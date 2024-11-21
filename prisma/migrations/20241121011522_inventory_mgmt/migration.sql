-- CreateEnum
CREATE TYPE "ProductType" AS ENUM ('digital', 'physical', 'service', 'bundle');

-- CreateEnum
CREATE TYPE "ProductCategory" AS ENUM ('airtime', 'voucher', 'subscription', 'ebook', 'gaming', 'utilities', 'entertainment', 'license', 'electronics', 'apparel', 'appliance', 'books', 'cosmetics', 'groceries', 'bundle', 'service');

-- CreateEnum
CREATE TYPE "TxnStatus" AS ENUM ('unstarted', 'processing', 'successful', 'cancelled', 'failed', 'refundRequested', 'refundProcesing', 'refundSuccess', 'refundDenied', 'refundFailed');

-- CreateEnum
CREATE TYPE "PaymentMethod" AS ENUM ('card', 'cash', 'mtnMomo', 'vodaCash', 'airtelTigoMoney', 'paypal', 'applePay', 'googlePay');

-- CreateEnum
CREATE TYPE "InventoryTxnType" AS ENUM ('restock', 'sale', 'return');

-- CreateTable
CREATE TABLE "InventoryTxn" (
    "id" SERIAL NOT NULL,
    "type" "InventoryTxnType" NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "quantity" INTEGER NOT NULL,
    "costPrice" INTEGER,
    "sellingPrice" INTEGER NOT NULL,
    "productOptionId" INTEGER NOT NULL,
    "orderItemId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "InventoryTxn_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Product" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "details" TEXT NOT NULL DEFAULT '',
    "images" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "active" BOOLEAN NOT NULL DEFAULT true,
    "currency" TEXT NOT NULL,
    "type" "ProductType" NOT NULL,
    "category" "ProductCategory" NOT NULL,
    "storeId" TEXT NOT NULL,
    "uploadedById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Product_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductVariant" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "details" TEXT NOT NULL DEFAULT '',
    "active" BOOLEAN NOT NULL DEFAULT true,
    "productId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProductVariant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductVariantProperty" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "details" TEXT NOT NULL DEFAULT '',
    "optionRegex" TEXT,
    "productVariantId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProductVariantProperty_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductVariantPropertyOption" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "details" TEXT NOT NULL DEFAULT '',
    "images" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "price" INTEGER,
    "minPrice" INTEGER,
    "maxPrice" INTEGER,
    "inventory" INTEGER NOT NULL DEFAULT 0,
    "variantPropertyId" INTEGER NOT NULL,
    "createdById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProductVariantPropertyOption_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductOptionDiscount" (
    "id" SERIAL NOT NULL,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "code" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "percentage" DECIMAL(65,30),
    "amount" INTEGER,
    "activeFrom" TIMESTAMP(3),
    "activeTo" TIMESTAMP(3),
    "daysDuration" INTEGER,
    "createdById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ProductOptionDiscount_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WishlistItem" (
    "id" SERIAL NOT NULL,
    "productId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,

    CONSTRAINT "WishlistItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CartItem" (
    "id" SERIAL NOT NULL,
    "quantity" INTEGER NOT NULL,
    "totalCost" INTEGER NOT NULL,
    "userId" TEXT NOT NULL,
    "productOptionId" INTEGER NOT NULL,

    CONSTRAINT "CartItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrderItem" (
    "id" SERIAL NOT NULL,
    "unitPrice" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL,
    "totalCost" INTEGER NOT NULL,
    "tax" INTEGER,
    "refundAmount" INTEGER,
    "currency" TEXT NOT NULL,
    "txnResponse" JSONB,
    "status" "TxnStatus" NOT NULL DEFAULT 'unstarted',
    "productOptionId" INTEGER NOT NULL,
    "orderId" TEXT NOT NULL,

    CONSTRAINT "OrderItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrderItemDiscount" (
    "id" SERIAL NOT NULL,
    "periodStart" TIMESTAMP(3),
    "periodEnd" TIMESTAMP(3),
    "discountId" INTEGER NOT NULL,
    "orderItemId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "OrderItemDiscount_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Order" (
    "id" TEXT NOT NULL,
    "totalCost" INTEGER NOT NULL,
    "purchasedById" TEXT NOT NULL,
    "status" "TxnStatus" NOT NULL DEFAULT 'unstarted',
    "paymentMethod" "PaymentMethod" NOT NULL DEFAULT 'cash',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "completedAt" TIMESTAMP(3),

    CONSTRAINT "Order_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_ProductOptionDiscountToProductVariantPropertyOption" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "InventoryTxn_productOptionId_orderItemId_key" ON "InventoryTxn"("productOptionId", "orderItemId");

-- CreateIndex
CREATE UNIQUE INDEX "ProductOptionDiscount_code_key" ON "ProductOptionDiscount"("code");

-- CreateIndex
CREATE UNIQUE INDEX "WishlistItem_productId_userId_key" ON "WishlistItem"("productId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "CartItem_productOptionId_userId_key" ON "CartItem"("productOptionId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "OrderItem_productOptionId_orderId_key" ON "OrderItem"("productOptionId", "orderId");

-- CreateIndex
CREATE UNIQUE INDEX "OrderItemDiscount_orderItemId_key" ON "OrderItemDiscount"("orderItemId");

-- CreateIndex
CREATE UNIQUE INDEX "_ProductOptionDiscountToProductVariantPropertyOption_AB_unique" ON "_ProductOptionDiscountToProductVariantPropertyOption"("A", "B");

-- CreateIndex
CREATE INDEX "_ProductOptionDiscountToProductVariantPropertyOption_B_index" ON "_ProductOptionDiscountToProductVariantPropertyOption"("B");

-- AddForeignKey
ALTER TABLE "InventoryTxn" ADD CONSTRAINT "InventoryTxn_productOptionId_fkey" FOREIGN KEY ("productOptionId") REFERENCES "ProductVariantPropertyOption"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "InventoryTxn" ADD CONSTRAINT "InventoryTxn_orderItemId_fkey" FOREIGN KEY ("orderItemId") REFERENCES "OrderItem"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductVariant" ADD CONSTRAINT "ProductVariant_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductVariantProperty" ADD CONSTRAINT "ProductVariantProperty_productVariantId_fkey" FOREIGN KEY ("productVariantId") REFERENCES "ProductVariant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductVariantPropertyOption" ADD CONSTRAINT "ProductVariantPropertyOption_variantPropertyId_fkey" FOREIGN KEY ("variantPropertyId") REFERENCES "ProductVariantProperty"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WishlistItem" ADD CONSTRAINT "WishlistItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CartItem" ADD CONSTRAINT "CartItem_productOptionId_fkey" FOREIGN KEY ("productOptionId") REFERENCES "ProductVariantPropertyOption"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrderItem" ADD CONSTRAINT "OrderItem_productOptionId_fkey" FOREIGN KEY ("productOptionId") REFERENCES "ProductVariantPropertyOption"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrderItem" ADD CONSTRAINT "OrderItem_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES "Order"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrderItemDiscount" ADD CONSTRAINT "OrderItemDiscount_discountId_fkey" FOREIGN KEY ("discountId") REFERENCES "ProductOptionDiscount"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrderItemDiscount" ADD CONSTRAINT "OrderItemDiscount_orderItemId_fkey" FOREIGN KEY ("orderItemId") REFERENCES "OrderItem"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ProductOptionDiscountToProductVariantPropertyOption" ADD CONSTRAINT "_ProductOptionDiscountToProductVariantPropertyOption_A_fkey" FOREIGN KEY ("A") REFERENCES "ProductOptionDiscount"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ProductOptionDiscountToProductVariantPropertyOption" ADD CONSTRAINT "_ProductOptionDiscountToProductVariantPropertyOption_B_fkey" FOREIGN KEY ("B") REFERENCES "ProductVariantPropertyOption"("id") ON DELETE CASCADE ON UPDATE CASCADE;
