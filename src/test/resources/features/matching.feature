Feature: Matching Rules

  Scenario: Two orders matched
    Given The exchange system contains:
      | Status | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN   | SELL      | VOD.L | 1000     | 100.2 | User1 | 1  |
    When I add a new order:
      | Direction | RIC   | Quantity | Price | User  | ID |
      | BUY       | VOD.L | 1000     | 100.3 | User2 | 2  |
    And There are no open orders
    Then The executed orders contains the following orders:
      | Status   | Direction | RIC   | Quantity | Price | User  | ID |
      | EXECUTED | SELL      | VOD.L | 1000     | 100.3 | User1 | 1  |
      | EXECUTED | BUY       | VOD.L | 1000     | 100.3 | User2 | 2  |
    And The Average execution for 'VOD.L' is 100.3
    And The Executed quantity for 'VOD.L' and 'User1' is -1000
    And The Executed quantity for 'VOD.L' and 'User2' is 1000

  Scenario: Multiple matching orders at the same price
    Given The exchange system contains:
      | Status | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN   | BUY       | VOD.L | 1000     | 100.2 | User1 | 1  |
      | OPEN   | BUY       | VOD.L | 1000     | 100.2 | User2 | 2  |
    When I add a new order:
      | Direction | RIC   | Quantity | Price | User  | ID |
      | SELL      | VOD.L | 1000     | 100.2 | User3 | 3  |
    Then The open orders contains the following orders:
      | Status | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN   | BUY       | VOD.L | 1000     | 100.2 | User2 | 2  |
    Then The executed orders contains the following orders:
      | Status   | Direction | RIC   | Quantity | Price | User  | ID |
      | EXECUTED | BUY       | VOD.L | 1000     | 100.2 | User1 | 1  |
      | EXECUTED | SELL      | VOD.L | 1000     | 100.2 | User3 | 3  |
    And The Average execution for 'VOD.L' is 100.2
    And The Executed quantity for 'VOD.L' and 'User1' is 1000
    And The Executed quantity for 'VOD.L' and 'User3' is -1000

  Scenario: Multiple matching orders at different prices for a new sell order
    Given The exchange system contains:
      | Status | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN   | BUY       | VOD.L | 1000     | 100.2 | User1 | 1  |
      | OPEN   | BUY       | VOD.L | 1000     | 100.3 | User2 | 2  |
    And There are no execute orders
    When I add a new order:
      | Direction | RIC   | Quantity | Price | User  | ID |
      | SELL      | VOD.L | 1000     | 100.1 | User3 | 3  |
    Then The open orders contains the following orders:
      | Status | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN   | BUY       | VOD.L | 1000     | 100.2 | User1 | 1  |
    Then The executed orders contains the following orders:
      | Status   | Direction | RIC   | Quantity | Price | User  | ID |
      | EXECUTED | BUY       | VOD.L | 1000     | 100.1 | User2 | 2  |
      | EXECUTED | SELL      | VOD.L | 1000     | 100.1 | User3 | 3  |
    And The Average execution for 'VOD.L' is 100.1
    And The Executed quantity for 'VOD.L' and 'User2' is 1000
    And The Executed quantity for 'VOD.L' and 'User3' is -1000

  Scenario: Multiple matching orders at different prices for a new buy order
    Given The exchange system contains:
      | Status | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN   | SELL      | VOD.L | 1000     | 100.2 | User1 | 1  |
      | OPEN   | SELL      | VOD.L | 1000     | 100.3 | User2 | 2  |
    And There are no execute orders
    When I add a new order:
      | Direction | RIC   | Quantity | Price | User  | ID |
      | BUY       | VOD.L | 1000     | 100.4 | User3 | 3  |
    Then The open orders contains the following orders:
      | Status | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN   | SELL      | VOD.L | 1000     | 100.3 | User2 | 2  |
    Then The executed orders contains the following orders:
      | Status   | Direction | RIC   | Quantity | Price | User  | ID |
      | EXECUTED | SELL      | VOD.L | 1000     | 100.4 | User1 | 1  |
      | EXECUTED | BUY       | VOD.L | 1000     | 100.4 | User3 | 3  |
    And The Average execution for 'VOD.L' is 100.4
    And The Executed quantity for 'VOD.L' and 'User1' is -1000
    And The Executed quantity for 'VOD.L' and 'User3' is 1000