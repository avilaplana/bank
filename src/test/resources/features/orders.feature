Feature: Orders

  Scenario: Add first order
    Given The exchange system is empty
    When I add a new order:
      | Direction | RIC   | Quantity | Price | User  | ID |
      | SELL      | VOD.L | 1000     | 100.2 | User1 | 1  |
    Then The open orders contains the following orders:
      | Status | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN   | SELL      | VOD.L | 1000     | 100.2 | User1 | 1  |
    And There are no execute orders
    And The Open interest for 'VOD.L' and 'SELL' is:
      | Status | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN   | SELL      | VOD.L | 1000     | 100.2 | User1 | 1  |

  Scenario: Add second order
    Given The exchange system contains:
      | Status | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN   | SELL      | VOD.L | 1000     | 100.2 | User1 | 1  |
    When I add a new order:
      | Direction | RIC   | Quantity | Price | User  | ID |
      | BUY       | VOD.L | 1000     | 100.2 | User2 | 2  |
    And There are no open orders
    Then The executed orders contains the following orders:
      | Status   | Direction | RIC   | Quantity | Price | User  | ID |
      | EXECUTED | SELL      | VOD.L | 1000     | 100.2 | User1 | 1  |
      | EXECUTED | BUY       | VOD.L | 1000     | 100.2 | User2 | 2  |
    And The Average execution for 'VOD.L' is 100.2
    And The Executed quantity for 'VOD.L' and 'User1' is -1000
    And The Executed quantity for 'VOD.L' and 'User2' is 1000

  Scenario: Add third order
    Given The exchange system contains:
      | Status   | Direction | RIC   | Quantity | Price | User  | ID |
      | EXECUTED | SELL      | VOD.L | 1000     | 100.2 | User1 | 1  |
      | EXECUTED | BUY       | VOD.L | 1000     | 100.2 | User2 | 2  |
    When I add a new order:
      | Direction | RIC   | Quantity | Price | User  | ID |
      | BUY       | VOD.L | 1000     | 99    | User1 | 3  |
    Then The open orders contains the following orders:
      | Status | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN   | BUY       | VOD.L | 1000     | 99    | User1 | 3  |
    Then The executed orders contains the following orders:
      | Status   | Direction | RIC   | Quantity | Price | User  | ID |
      | EXECUTED | SELL      | VOD.L | 1000     | 100.2 | User1 | 1  |
      | EXECUTED | BUY       | VOD.L | 1000     | 100.2 | User2 | 2  |
    And The Open interest for 'VOD.L' and 'BUY' is:
      | Status | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN   | BUY       | VOD.L | 1000     | 99    | User1 | 3  |
    And The Executed quantity for 'VOD.L' and 'User1' is -1000
    And The Executed quantity for 'VOD.L' and 'User2' is 1000

  Scenario: Add fourth order
    Given The exchange system contains:
      | Status   | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN     | BUY       | VOD.L | 1000     | 99    | User1 | 1  |
      | EXECUTED | SELL      | VOD.L | 1000     | 100.2 | User1 | 2  |
      | EXECUTED | BUY       | VOD.L | 1000     | 100.2 | User2 | 3  |
    When I add a new order:
      | Direction | RIC   | Quantity | Price | User  | ID |
      | BUY       | VOD.L | 1000     | 101   | User1 | 4  |
    Then The open orders contains the following orders:
      | Status | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN   | BUY       | VOD.L | 1000     | 99    | User1 | 1  |
      | OPEN   | BUY       | VOD.L | 1000     | 101   | User1 | 4  |
    Then The executed orders contains the following orders:
      | Status   | Direction | RIC   | Quantity | Price | User  | ID |
      | EXECUTED | SELL      | VOD.L | 1000     | 100.2 | User1 | 2  |
      | EXECUTED | BUY       | VOD.L | 1000     | 100.2 | User2 | 3  |
    And The Open interest for 'VOD.L' and 'BUY' is:
      | Status | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN   | BUY       | VOD.L | 1000     | 99    | User1 | 1  |
      | OPEN   | BUY       | VOD.L | 1000     | 101   | User1 | 4  |
    And The Executed quantity for 'VOD.L' and 'User1' is -1000
    And The Executed quantity for 'VOD.L' and 'User2' is 1000

  Scenario: Add fifth order
    Given The exchange system contains:
      | Status   | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN     | BUY       | VOD.L | 1000     | 99    | User1 | 1  |
      | OPEN     | BUY       | VOD.L | 1000     | 101   | User1 | 2  |
      | EXECUTED | SELL      | VOD.L | 1000     | 100.2 | User1 | 3  |
      | EXECUTED | BUY       | VOD.L | 1000     | 100.2 | User2 | 4  |
    When I add a new order:
      | Direction | RIC   | Quantity | Price | User  | ID |
      | SELL      | VOD.L | 500      | 102   | User2 | 5  |
    Then The open orders contains the following orders:
      | Status | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN   | BUY       | VOD.L | 1000     | 99    | User1 | 1  |
      | OPEN   | BUY       | VOD.L | 1000     | 101   | User1 | 2  |
      | OPEN   | SELL      | VOD.L | 500      | 102   | User2 | 5  |
    Then The executed orders contains the following orders:
      | Status   | Direction | RIC   | Quantity | Price | User  | ID |
      | EXECUTED | SELL      | VOD.L | 1000     | 100.2 | User1 | 3  |
      | EXECUTED | BUY       | VOD.L | 1000     | 100.2 | User2 | 4  |
    And The Open interest for 'VOD.L' and 'BUY' is:
      | Status | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN   | BUY       | VOD.L | 1000     | 99    | User1 | 1  |
      | OPEN   | BUY       | VOD.L | 1000     | 101   | User1 | 2  |
    And The Open interest for 'VOD.L' and 'SELL' is:
      | Status | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN   | SELL      | VOD.L | 500      | 102   | User2 | 5  |
    And The Executed quantity for 'VOD.L' and 'User1' is -1000
    And The Executed quantity for 'VOD.L' and 'User2' is 1000


  Scenario: Add sixth order
    Given The exchange system contains:
      | Status   | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN     | BUY       | VOD.L | 1000     | 99    | User1 | 1  |
      | OPEN     | BUY       | VOD.L | 1000     | 101   | User1 | 2  |
      | OPEN     | SELL      | VOD.L | 500      | 102   | User2 | 3  |
      | EXECUTED | SELL      | VOD.L | 1000     | 100.2 | User1 | 4  |
      | EXECUTED | BUY       | VOD.L | 1000     | 100.2 | User2 | 5  |
    When I add a new order:
      | Direction | RIC   | Quantity | Price | User  | ID |
      | BUY       | VOD.L | 500      | 103   | User1 | 6  |
    Then The open orders contains the following orders:
      | Status | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN   | BUY       | VOD.L | 1000     | 99    | User1 | 1  |
      | OPEN   | BUY       | VOD.L | 1000     | 101   | User1 | 2  |
    Then The executed orders contains the following orders:
      | Status   | Direction | RIC   | Quantity | Price | User  | ID |
      | EXECUTED | SELL      | VOD.L | 1000     | 100.2 | User1 | 4  |
      | EXECUTED | BUY       | VOD.L | 1000     | 100.2 | User2 | 5  |
      | EXECUTED | SELL      | VOD.L | 500      | 103   | User2 | 3  |
      | EXECUTED | BUY       | VOD.L | 500      | 103   | User1 | 6  |
    And The Open interest for 'VOD.L' and 'BUY' is:
      | Status | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN   | BUY       | VOD.L | 1000     | 99    | User1 | 1  |
      | OPEN   | BUY       | VOD.L | 1000     | 101   | User1 | 2  |
    And The Average execution for 'VOD.L' is 101.6
    And The Executed quantity for 'VOD.L' and 'User1' is -500
    And The Executed quantity for 'VOD.L' and 'User2' is 500

  Scenario: Add seventh order
    Given The exchange system contains:
      | Status   | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN     | BUY       | VOD.L | 1000     | 99    | User1 | 1  |
      | OPEN     | BUY       | VOD.L | 1000     | 101   | User1 | 2  |
      | EXECUTED | SELL      | VOD.L | 1000     | 100.2 | User1 | 3  |
      | EXECUTED | BUY       | VOD.L | 1000     | 100.2 | User2 | 4  |
      | EXECUTED | SELL      | VOD.L | 500      | 103   | User2 | 5  |
      | EXECUTED | BUY       | VOD.L | 500      | 103   | User1 | 6  |
    When I add a new order:
      | Direction | RIC   | Quantity | Price | User  | ID |
      | SELL      | VOD.L | 1000     | 98    | User2 | 7  |
    Then The open orders contains the following orders:
      | Status | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN   | BUY       | VOD.L | 1000     | 99    | User1 | 1  |
    Then The executed orders contains the following orders:
      | Status   | Direction | RIC   | Quantity | Price | User  | ID |
      | EXECUTED | SELL      | VOD.L | 1000     | 100.2 | User1 | 3  |
      | EXECUTED | BUY       | VOD.L | 1000     | 100.2 | User2 | 4  |
      | EXECUTED | SELL      | VOD.L | 500      | 103   | User2 | 5  |
      | EXECUTED | BUY       | VOD.L | 500      | 103   | User1 | 6  |
      | EXECUTED | BUY       | VOD.L | 1000     | 98    | User1 | 2  |
      | EXECUTED | SELL      | VOD.L | 1000     | 98    | User2 | 7  |
    And The Open interest for 'VOD.L' and 'BUY' is:
      | Status | Direction | RIC   | Quantity | Price | User  | ID |
      | OPEN   | BUY       | VOD.L | 1000     | 99    | User1 | 1  |
    And The Average execution for 'VOD.L' is 100.4
    And The Executed quantity for 'VOD.L' and 'User1' is 500
    And The Executed quantity for 'VOD.L' and 'User2' is -500
#
