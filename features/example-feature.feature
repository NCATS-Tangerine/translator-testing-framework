Feature: Create a feature to help demo Behave

  Scenario: A deck of cards should have 52 unique cards
    Given "1" decks of cards from "https://deckofcardsapi.com/api/deck/"
    When we draw "5" cards
    Then our deck should have "47" cards remaining
    Then our deck should not still contain any cards that are in our hand
