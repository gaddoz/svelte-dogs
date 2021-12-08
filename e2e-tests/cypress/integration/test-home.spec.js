const { internet } = require('faker');

describe('test home', () => {
  before(() => {
    cy.log('will start home test');
  });

  it('should load homepage', () => {
    cy.visit('');
    cy.contains('svelte dogs').should('be.visible');
    cy.screenshot();
  });

  it('should load homepage (iphone view)', () => {
    cy.viewport('iphone-6');
    cy.visit('');
    cy.contains('svelte dogs').should('be.visible');
    cy.screenshot();
  });

});
