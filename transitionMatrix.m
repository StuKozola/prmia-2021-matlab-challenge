function transitions = transitionMatrix(migrationHistory)

% convert input into a table with column metadata
migrationEvents = cell2table(migrationHistory);
migrationEvents.Properties.VariableNames = {'ID','Date','Rating'};
migrationEvents.Date = datetime(migrationEvents.Date);
migrationEvents.Rating = categorical(migrationEvents.Rating);

% calculate the transition probability matrix for the years 1986 to 2000
transitions = transprob(migrationEvents, 'startDate', '12/31/1986', 'endDate', '12/31/2000') / 100;


