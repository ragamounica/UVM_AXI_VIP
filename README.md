# AXI Protocol Verification using SystemVerilog UVM

This project demonstrates functional verification of an AXI protocol interface, implemented entirely using SystemVerilog and UVM. The goal is to showcase protocol-level verification skills, reusable verification IP (VIP), and professional-grade verification methodology.

---

**Overview**

- **Protocol:** AMBA AXI (AXI4)
- **Verification Methodology:** Universal Verification Methodology (UVM)
- **Language:** SystemVerilog
- **Target Simulators:** QuestaSim / VCS / ModelSim

The verification environment covers AXI protocol compliance, transaction-level stimulus generation, functional coverage, assertions, and corner-case scenario verification.

---

**Key Highlights**

- Complete AXI VIP developed using UVM methodology.
- UVM components: Driver, Monitor, Sequencer, Agent, Scoreboard, and Environment.
- Constrained-random stimulus for both read and write channels.
- Functional coverage models ensuring protocol correctness and coverage closure.
- Assertions (SystemVerilog SVA) to validate protocol properties.
- Easy extensibility for future AXI protocol extensions.

---

**Project Structure**

AXI_VIP/
│
├── doc/       # Specifications, block diagrams, verification plan
├── rtl/       # DUT (Design Under Test) files
├── tb/        # Testbench top-level and interface files
├── env/       # Complete UVM Environment (agent, driver, monitor, scoreboard, sequences)
├── sim/       # Simulation scripts, configurations
├── logs/      # Simulation logs and coverage reports
└── README.md  # Project documentation

---

**Technical Skills Demonstrated**

- UVM Verification IP Development
- Transaction-level Modeling (TLM)
- Constrained Random Verification (CRV)
- Functional & Code Coverage Closure
- Protocol Assertion Development (SVA)
- AXI4 Protocol Expertise

---

**Contact**

If you're a hiring manager, recruiter, or engineer and would like to discuss this project:

- **Email:** [YourEmail@example.com]
- **LinkedIn:** [LinkedIn Profile URL]

---

*This repository is part of my personal verification portfolio demonstrating real-world design verification skills on industry-standard protocols.*