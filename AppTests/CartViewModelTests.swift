//
//  CartViewModelTests.swift
//  AppTests
//
//  Created by Irinka Datoshvili on 12.05.24.
//

import XCTest
@testable import UnitTestingAssignment

final class CartViewModelTests: XCTestCase {
    
    var cartViewModel: CartViewModel!
    
    override func setUpWithError() throws {
        cartViewModel = CartViewModel()
    }
    
    override func tearDownWithError() throws {
        cartViewModel = nil
    }
    
    // MARK: - Test Cases
    
    func testAddProduct() {
        let product = Product(id: 1, title: "Test Product", description: "Test Description", price: 10.0, selectedQuantity: 1)
        cartViewModel.addProduct(product: product)
        
        XCTAssertEqual(cartViewModel.selectedProducts.count, 1)
        XCTAssertEqual(cartViewModel.selectedProducts.first?.id, product.id)
    }
    
    func testAddProductWithID() {
        let id = 2
        let expectation = XCTestExpectation(description: "Add Product")
        cartViewModel.fetchProducts()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.cartViewModel.addProduct(withID: id)
            XCTAssertEqual(self.cartViewModel.selectedProducts.count, 1)
            XCTAssertEqual(self.cartViewModel.selectedProducts.first?.id, id)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testRemoveProduct() {
        let product = Product(id: 1, title: "Test Product", description: "Test Description", price: 10.0, selectedQuantity: 1)
        cartViewModel.addProduct(product: product)
        cartViewModel.removeProduct(withID: 1)
        
        XCTAssertEqual(cartViewModel.selectedProducts.count, 0)
    }
    
    func testFetchProducts() {
        let expectation = XCTestExpectation(description: "Fetch products")
        
        cartViewModel.fetchProducts()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertNotNil(self.cartViewModel.allProducts)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testAddRandomProduct() {
        let expectation = XCTestExpectation(description: "Add random product")
        
        cartViewModel.fetchProducts()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.cartViewModel.addRandomProduct()
            XCTAssertGreaterThan(self.cartViewModel.selectedProducts.count, 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testClearCart() {
        let product = Product(id: 1, title: "Test Product", description: "Test Description", price: 10.0, selectedQuantity: 1)
        cartViewModel.addProduct(product: product)
        
        cartViewModel.clearCart()
        
        XCTAssertEqual(cartViewModel.selectedProducts.count, 0)
    }
    
    func testViewDidLoad() {
        let expectation = XCTestExpectation(description: "Fetch products")
        cartViewModel.fetchProducts()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertNotNil(self.cartViewModel.allProducts)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testSelectedItemsQuantity() {
        let product1 = Product(id: 1, title: "Product 1", price: 10.0, selectedQuantity: 2)
        let product2 = Product(id: 2, title: "Product 2", price: 15.0, selectedQuantity: 1)
        cartViewModel.selectedProducts = [product1, product2]
        let expectedQuantity = product1.selectedQuantity! + product2.selectedQuantity!
        
        XCTAssertEqual(cartViewModel.selectedItemsQuantity, expectedQuantity)
    }
    
    
    func testTotalPrice() {
        let expectation = XCTestExpectation(description: "Fetch products")
        cartViewModel.fetchProducts()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if let products = self.cartViewModel.allProducts {
                self.cartViewModel.selectedProducts.append(products[0])
                self.cartViewModel.selectedProducts.append(products[1])
                let totalPrice = self.cartViewModel.selectedProducts[0].price! + self.cartViewModel.selectedProducts[1].price!
                
                XCTAssertEqual(totalPrice, 1448.0)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
