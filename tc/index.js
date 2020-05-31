/**
 * Mission op placement
 *
 * @param {[string]} names Ordered list of mission names
 * @param {[string]} completedNames=[] Ordered list of completed mission names
 * @returns {Array} Missions rows with names of each operator for each mission
 */
const missions = (names, completedNames = []) => {
  const raw = {
    fields: ['Mission', 'Snek', 'Zloy', 'Dutch', 'Diana', 'Charon', 'Varg', 'David', 'Syndrome', 'Joe', 'Valera', 'Capisce', 'Klaus', 'Shi', 'Victor', 'Spencer', 'Travis', 'Batya', 'Hawk', 'Jason', 'Boris', 'Thor', 'Rick', 'Mishka', 'Rookie'],
    data: [
      ['B.S.S.', 200, 200, 200, 200, 200, 255, 95, 95, 95, 95, 95, 70, 70, 70, 190, 70, 70, 60, 160, 60, 60, 60, 60, 50],
      ['Basic Mission', 200, 200, 200, 200, 200, 160, 160, 160, 160, 160, 160, 120, 120, 120, 120, 120, 120, 100, 100, 100, 100, 100, 100, 80],
      ['Bayonet', 200, 200, 200, 200, 200, 65, 210, 65, 65, 65, 65, 155, 155, 155, 155, 155, 50, 40, 150, 150, 150, 150, 40, 35],
      ['Breach', 200, 200, 200, 200, 200, 115, 115, 240, 115, 115, 115, 85, 85, 180, 85, 85, 85, 70, 70, 150, 70, 70, 70, 55],
      ['Cleanup', 200, 200, 200, 200, 200, 115, 115, 115, 240, 115, 115, 85, 85, 85, 180, 85, 85, 70, 70, 70, 150, 70, 70, 55],
      ['Common Only', 200, 200, 200, 200, 200, 65, 65, 65, 65, 65, 65, 50, 50, 50, 50, 50, 50, 150, 150, 150, 150, 150, 150, 120],
      ['Cover', 200, 200, 200, 200, 200, 115, 115, 115, 115, 240, 115, 85, 85, 85, 85, 180, 85, 70, 70, 70, 70, 150, 70, 55],
      ['Hammer', 200, 200, 200, 200, 200, 95, 95, 95, 95, 95, 95, 240, 70, 70, 70, 70, 240, 60, 60, 190, 60, 190, 190, 50],
      ['HILDR', 200, 200, 200, 200, 200, 480, 100, 100, 100, 100, 100, 70, 70, 70, 70, 70, 70, 60, 60, 60, 300, 60, 60, 50],
      ['Knife', 200, 200, 200, 200, 200, 90, 90, 90, 90, 320, 90, 65, 240, 240, 65, 240, 65, 55, 55, 55, 55, 55, 55, 45],
      ['Locals', 200, 200, 200, 200, 200, 80, 80, 225, 225, 80, 225, 60, 60, 60, 60, 60, 170, 140, 50, 50, 50, 50, 140, 40],
      ['Logistics', 200, 200, 200, 200, 200, 115, 240, 115, 115, 115, 115, 85, 180, 85, 85, 85, 85, 70, 150, 70, 70, 70, 70, 55],
      ['Rare Only', 200, 200, 200, 200, 200, 240, 240, 240, 240, 240, 240, 50, 50, 50, 50, 50, 50, 40, 40, 40, 40, 40, 40, 30],
      ['Recon', 200, 200, 200, 200, 200, 240, 115, 115, 115, 115, 115, 180, 85, 85, 85, 85, 85, 150, 70, 70, 70, 70, 70, 55],
      ['Showdown', 200, 200, 200, 200, 200, 115, 115, 115, 115, 115, 240, 85, 85, 85, 85, 85, 180, 70, 70, 70, 70, 70, 150, 55],
      ['Uncommon Only', 200, 200, 200, 200, 200, 65, 65, 65, 65, 65, 65, 180, 180, 180, 180, 180, 180, 40, 40, 40, 40, 40, 40, 30],
    ],
  };

  /**
   * Helper function that ignores first column
   *
   * @param {any} y Column value
   * @param {Number} i Column index
   * @param {any} expr Any expression
   * @returns {any} Either first element or expr
   */
  const first = (y, i, expr) => (i === 0 ? y : expr);

  /**
   * Get ordered, filtered list of missions with data and zeroed data for completed missions
   *
   * @param {[string]} all Mission names
   * @param {[string]} complete Completed mission names
   * @returns {Array} Missions rows with values for each operator for each mission
   */
  const calcBase = (all, complete) => (
    // use the all array to maintain its ordering
    all
      .map((x) => (raw.data.find((y) => y[0] === x)))
      .map((x) => (
        // zero completed rows
        complete.includes(x[0]) ? x.map((y, i) => (first(y, i, 0))) : x
      ))
  );

  /**
   * Get the max for each operator of the current missions
   *
   * @param {Array} current Missions rows
   * @returns {Array} Single row
   */
  const calcMax = (current) => (
    current.reduce((acc, x) => (
      acc.map((y, i) => (
        first(y, i, Math.max(parseInt(y, 10), parseInt(x[i], 10)))
      ))
    ))
  );

  /**
   * All Ops that match the max value
   *
   * @param {Array} current Missions rows with integer performance for each op
   * @param {Array} max Single row with max values
   * @returns {Array} Missions rows with booleans
   */
  const calcRawOps = (current, max) => (
    current.map((x) => (
      x.map((y, i) => (first(y, i, y === max[i])))
    ))
  );

  /**
   * Only use the op from the highest mission or last if equal
   *
   * @param {Array} rawOps Missions rows with booleans
   * @returns {Array} Missions rows with booleans
   */
  const calcOps = (rawOps) => {
    // use final mission as default
    const final = rawOps.slice(-1)[0];
    // have to do all this destructuring to avoid mutating the array which
    // seems to hold a reference to data still
    const [, ...tail] = final;
    // use last row as a tracker of which ops have been assigned
    const init = ['Assigned', ...tail];

    // start from final mission and work backwards
    const opsData = rawOps.reduceRight((acc, x) => {
      if (acc.length === 1) {
        return [x, ...acc];
      }
      const assigned = acc.slice(-1)[0];
      // rest
      const current = acc.slice(0, -1);
      // current mission that assigns ops that haven't already been assigned
      const newX = x.map((y, i) => (
        first(y, i, assigned[i] ? false : y)
      ));
      // include new assignees in assigned row
      const newAssigned = assigned.map((y, i) => (
        first(y, i, newX[i] ? true : y)
      ));
      return [newX, ...current, newAssigned];
    }, [init]);
    return opsData.slice(0, -1); // remove assigned tracker row
  };

  /**
   * Replace the true cells with op name and all others blank
   *
   * @param {Array} rawOps Missions rows with booleans
   * @returns {Array} Missions rows with strings
   */
  const calcOpNames = (ops) => (
    ops.map((x) => (
      x.map((y, i) => (
        first(y, i, y ? raw.fields[i] : '')
      ))
    ))
  );

  /**
   * Replace the true cells with op name and all others blank
   *
   * @param {Array} rawOps Missions rows with booleans
   * @returns {Array} Missions rows with strings
   */
  const calcChanges = (current, previous) => (
    current.map((x, i) => (
      x.map((y, j) => (
        y === previous[i][j] ? y : y.toUpperCase()
      ))
    ))
  );

  /**
   * Put the calculations together, this is repeated for next and previous
   *
   * @param {[string]} completed Ordered list of completed mission names
   * @returns {Array} Mission rows with string operator names
   */
  const calc = (completed) => {
    const base = calcBase(names, completed);
    const rawOps = calcRawOps(base, calcMax(base));
    const ops = calcOps(rawOps);
    return calcOpNames(ops);
  };

  // compare current and previous
  return calcChanges(calc(completedNames), calc(completedNames.slice(0, -1)));
};

// example usage
console.log(missions(
  ['Hammer', 'Recon', 'Uncommon Only', 'Bayonet', 'Knife', 'Logistics'],
  ['Hammer', 'Recon', 'Logistics', 'Uncommon Only'],
));
