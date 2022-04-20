import Component from "@ember/component";
import I18n from "I18n";
import discourseComputed from "discourse-common/utils/decorators";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";

export default Component.extend({
  router: service(),
  tagName: "",

  init() {
    this._super(...arguments);
  },

  @action
  selectCustomQuery() {
    this.get("router").transitionTo("docs.index", {
      queryParams: {
        category: this.customQuery.category,
        tags: this.customQuery.tags,
        time: this.customQuery.time,
        groups: this.customQuery.groups,
      },
    });
  },

  @discourseComputed("tagIcons", "tag.id")
  tagIcon(tagIcons, id) {
    return tagIcons[id];
  },

  @discourseComputed()
  customQueryTitle() {
    return this.customQuery.name;
  },

  @discourseComputed()
  hasDescription() {
    return this.customQuery.description ? true : false;
  },

  @discourseComputed()
  customQueryDescription() {
    return this.customQuery.description;
  },
});
