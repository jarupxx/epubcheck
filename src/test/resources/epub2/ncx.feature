Feature: EPUB 2.0.1 Global Navigation (NCX)
  
  Checks conformance to rules for Global Navigation (NCX) defined in the Open
  Packaging Format (OPF) 2.0.1 specification:
  
    http://idpf.org/epub/20/spec/OPF_2.0.1_draft.htm#Section2.4.1
  
  This feature file contains tests for EPUBCheck running in default mode to check
  full EPUB publications
  
  Note:
  - Tests related to general EPUB 2.0.1 OPF feautres are defined in the `opf.feature` file   


  Background: 
    Given test files located at '/epub2/files/epub/'
    And EPUBCheck configured to check EPUB 2.0.1 rules

  ##  2.4.1: Declarative Global Navigation — the NCX

  ###  2.4.1.2: Key NCX Requirements

  Scenario: Report duplicate IDs in the NCX document
    When checking EPUB 'ncx-id-duplicate-error'
    Then the following errors are reported
      | RSC-005 | The "id" attribute does not have a unique value |
      | RSC-005 | The "id" attribute does not have a unique value |
    And no other errors or warnings are reported

  Scenario: Report invalid IDs in the NCX document
    When checking EPUB 'ncx-id-syntax-invalid-error'
    Then error RSC-005 is reported
    And the message contains 'value of attribute "id" is invalid'
    And no other errors or warnings are reported

  Scenario: Report an NCX reference to a resource that is not in the publication 
    When checking EPUB 'ncx-missing-resource-error'
    Then error RSC-007 is reported
    And no other errors or warnings are reported

  Scenario: Report an NCX `pageTarget` with a `type` attribute value that is not one of "front", "normal" or "special"
    When checking EPUB 'ncx-pagetarget-type-error'
    Then error RSC-005 is reported
    And the message contains 'value of attribute "type" is invalid'
    And no other errors or warnings are reported

  Scenario: Verify that leading/trailing spaces in an NCX `uid` attribute are allowed
    When checking EPUB 'ncx-uid-spaces-valid'
    Then no errors or warnings are reported

  Scenario: Report an NCX `uid` attribute value that does not match the publication's unique identifier (issue 329)
    When checking EPUB 'ncx-uid-mismatch-error'
    Then error NCX-001 is reported
    And no other errors or warnings are reported

  Scenario: Report empty text labels as usage
    Given the reporting level set to USAGE
    When checking EPUB 'ncx-label-empty-valid'
    Then usage NCX-006 is reported 2 times (1 for empty doc title, 1 for empty nav label)
    And no other errors or warnings are reported