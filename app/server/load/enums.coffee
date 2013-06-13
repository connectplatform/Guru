module.exports =
  staffRoles: ['Operator', 'Administrator', 'Owner', 'Supervisor'] # can log in as staff
  managerRoles: ['Administrator', 'Owner', 'Supervisor'] # can see all data for account
  editableRoles: ['Operator', 'Supervisor'] # can be selected in user management UI

  accountTypes: ['Paid', 'Unlimited']
  chatStatusStates: ['Waiting', 'Active', 'Vacant', 'Archived']
  chatSessionRelations: ['Member', 'Invite', 'Transfer', 'Watching', 'Visitor']
