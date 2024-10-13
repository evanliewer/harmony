window.BTPP = {
  debounce(func, timeout = 300) {
    let timer;
    return (...args) => {
      clearTimeout(timer);
      timer = setTimeout(() => {
        func.apply(this, args);
      }, timeout);
    };
  },
};

document.addEventListener("turbo:load", () => {
  document.querySelectorAll(".btpp-filter-form").forEach((form) => {
    form.addEventListener("turbo:submit-start", (event) => {
      event.detail.formSubmission.stop();

      const url = event.detail.formSubmission.fetchRequest.url;
      const context = url.searchParams.get("context");
      const collection = url.searchParams.get("collection");

      Turbo.visit(url.href, { frame: `${context}_${collection}` });

      // data-turbo-action="advance" takes too long
      history.pushState(
        Object.fromEntries(url.searchParams),
        "",
        new URL(url.search, location),
      );
    });

    // text fields
    form.querySelectorAll("input[type=text]").forEach((textInput) => {
      textInput.addEventListener(
        "input",
        window.BTPP.debounce(() => {
          form.requestSubmit();
        }),
      );
    });

    // super select fields
    form
      .querySelectorAll("[data-controller*='fields--super-select']")
      .forEach((superSelectInput) => {
        superSelectInput.addEventListener("$change", (event) => {
          form.requestSubmit();
        });
      });

    // buttons
    form
      .querySelectorAll("[data-controller*='fields--button-toggle'] > button")
      .forEach((buttonInput) => {
        buttonInput.addEventListener(
          "click",
          window.BTPP.debounce(() => {
            form.requestSubmit();
          }),
        );
      });
  });
});
