Feature: Orders

  Scenario: Add first order
    Given The exchange system is empty
    When I add a new order:
      | Direction | RIC   | Quantity | Price | User  |
      | SELL      | VOD.L | 1000     | 100.2 | User1 |
    Then The open orders contains the following orders:
      | Direction | RIC   | Quantity | Price | User  |
      | SELL      | VOD.L | 1000     | 100.2 | User1 |
    And There are no execute orders
    And The Open interest for 'VOD.L' and 'SELL' is:
      | Direction | RIC   | Quantity | Price | User  |
      | SELL      | VOD.L | 1000     | 100.2 | User1 |

  Scenario: Add second order
    Given The exchange system contains:
      | Type | Direction | RIC   | Quantity | Price | User  |
      | OPEN | SELL      | VOD.L | 1000     | 100.2 | User1 |
    When I add a new order:
      | Direction | RIC   | Quantity | Price | User  |
      | BUY       | VOD.L | 1000     | 100.2 | User2 |
    And There are no open orders
    Then The executed orders contains the following orders:
      | Direction | RIC   | Quantity | Price | User  |
      | SELL      | VOD.L | 1000     | 100.2 | User1 |
      | BUY       | VOD.L | 1000     | 100.2 | User2 |
    And The Average execution for 'VOD.L' is 100.2
    And The Executed quantity for 'VOD.L' and 'User1' is -1000
    And The Executed quantity for 'VOD.L' and 'User2' is 1000

  Scenario: Add third order
    Given The exchange system contains:
      | Type     | Direction | RIC   | Quantity | Price | User  |
      | EXECUTED | SELL      | VOD.L | 1000     | 100.2 | User1 |
      | EXECUTED | BUY       | VOD.L | 1000     | 100.2 | User2 |
    When I add a new order:
      | Direction | RIC   | Quantity | Price | User  |
      | BUY       | VOD.L | 1000     | 99    | User1 |
    Then The open orders contains the following orders:
      | Direction | RIC   | Quantity | Price | User  |
      | BUY       | VOD.L | 1000     | 99    | User1 |
    Then The executed orders contains the following orders:
      | Direction | RIC   | Quantity | Price | User  |
      | SELL      | VOD.L | 1000     | 100.2 | User1 |
      | BUY       | VOD.L | 1000     | 100.2 | User2 |

  Scenario: Add fourth order
    Given The exchange system contains:
      | Type     | Direction | RIC   | Quantity | Price | User  |
      | OPEN     | BUY       | VOD.L | 1000     | 99    | User1 |
      | EXECUTED | SELL      | VOD.L | 1000     | 100.2 | User1 |
      | EXECUTED | BUY       | VOD.L | 1000     | 100.2 | User2 |
    When I add a new order:
      | Direction | RIC   | Quantity | Price | User  |
      | BUY       | VOD.L | 1000     | 101   | User1 |
    Then The open orders contains the following orders:
      | Direction | RIC   | Quantity | Price | User  |
      | BUY       | VOD.L | 1000     | 99    | User1 |
      | BUY       | VOD.L | 1000     | 101   | User1 |
    Then The executed orders contains the following orders:
      | Direction | RIC   | Quantity | Price | User  |
      | SELL      | VOD.L | 1000     | 100.2 | User1 |
      | BUY       | VOD.L | 1000     | 100.2 | User2 |

  Scenario: Add fifth order
    Given The exchange system contains:
      | Type     | Direction | RIC   | Quantity | Price | User  |
      | OPEN     | BUY       | VOD.L | 1000     | 99    | User1 |
      | OPEN     | BUY       | VOD.L | 1000     | 101   | User1 |
      | EXECUTED | SELL      | VOD.L | 1000     | 100.2 | User1 |
      | EXECUTED | BUY       | VOD.L | 1000     | 100.2 | User2 |
    When I add a new order:
      | Direction | RIC   | Quantity | Price | User  |
      | SELL      | VOD.L | 500      | 102   | User2 |
    Then The open orders contains the following orders:
      | Direction | RIC   | Quantity | Price | User  |
      | BUY       | VOD.L | 1000     | 99    | User1 |
      | BUY       | VOD.L | 1000     | 101   | User1 |
      | SELL      | VOD.L | 500      | 102   | User2 |
    Then The executed orders contains the following orders:
      | Direction | RIC   | Quantity | Price | User  |
      | SELL      | VOD.L | 1000     | 100.2 | User1 |
      | BUY       | VOD.L | 1000     | 100.2 | User2 |

  Scenario: Add sixth order
    Given The exchange system contains:
      | Type     | Direction | RIC   | Quantity | Price | User  |
      | OPEN     | BUY       | VOD.L | 1000     | 99    | User1 |
      | OPEN     | BUY       | VOD.L | 1000     | 101   | User1 |
      | OPEN     | SELL      | VOD.L | 500      | 102   | User2 |
      | EXECUTED | SELL      | VOD.L | 1000     | 100.2 | User1 |
      | EXECUTED | BUY       | VOD.L | 1000     | 100.2 | User2 |
    When I add a new order:
      | Direction | RIC   | Quantity | Price | User  |
      | BUY       | VOD.L | 500      | 103   | User1 |
    Then The open orders contains the following orders:
      | Direction | RIC   | Quantity | Price | User  |
      | BUY       | VOD.L | 1000     | 99    | User1 |
      | BUY       | VOD.L | 1000     | 101   | User1 |
    Then The executed orders contains the following orders:
      | Direction | RIC   | Quantity | Price | User  |
      | SELL      | VOD.L | 1000     | 100.2 | User1 |
      | BUY       | VOD.L | 1000     | 100.2 | User2 |
      | SELL      | VOD.L | 500      | 103   | User2 |
      | BUY       | VOD.L | 500      | 103   | User1 |
    And The Average execution for 'VOD.L' is 101.6
    And The Executed quantity for 'VOD.L' and 'User1' is -500
    And The Executed quantity for 'VOD.L' and 'User2' is 500

  Scenario: Add seventh order
    Given The exchange system contains:
      | Type     | Direction | RIC   | Quantity | Price | User  |
      | OPEN     | BUY       | VOD.L | 1000     | 99    | User1 |
      | OPEN     | BUY       | VOD.L | 1000     | 101   | User1 |
      | EXECUTED | SELL      | VOD.L | 1000     | 100.2 | User1 |
      | EXECUTED | BUY       | VOD.L | 1000     | 100.2 | User2 |
      | EXECUTED | SELL      | VOD.L | 500      | 103   | User2 |
      | EXECUTED | BUY       | VOD.L | 500      | 103   | User1 |
    When I add a new order:
      | Direction | RIC   | Quantity | Price | User  |
      | SELL      | VOD.L | 1000     | 98    | User2 |
    Then The open orders contains the following orders:
      | Direction | RIC   | Quantity | Price | User  |
      | BUY       | VOD.L | 1000     | 99    | User1 |
    Then The executed orders contains the following orders:
      | Direction | RIC   | Quantity | Price | User  |
      | SELL      | VOD.L | 1000     | 100.2 | User1 |
      | BUY       | VOD.L | 1000     | 100.2 | User2 |
      | SELL      | VOD.L | 500      | 103   | User2 |
      | BUY       | VOD.L | 500      | 103   | User1 |
      | BUY       | VOD.L | 1000     | 98    | User1 |
      | SELL      | VOD.L | 1000     | 98    | User2 |
    And The Average execution for 'VOD.L' is 100.4
    And The Executed quantity for 'VOD.L' and 'User1' is 500
    And The Executed quantity for 'VOD.L' and 'User2' is -500

