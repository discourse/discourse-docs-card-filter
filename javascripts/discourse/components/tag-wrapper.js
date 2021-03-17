import Component from "@ember/component";
import I18n from "I18n";
import discourseComputed from "discourse-common/utils/decorators";
import { action } from "@ember/object";

export default Component.extend({
  tagName: "",

  init() {
    this._super(...arguments);
  },

  @action
  selectTag() {
    this.updateSelectedTag(this.tag)
  },

  @discourseComputed("tagIcons", "tag.id")
  tagIcon(tagIcons, id) {
    return tagIcons[id];
  },

  @discourseComputed("tag.id")
  tagTitle(tagTitle) {
    return tagTitle;
  },

  @discourseComputed("tag")
  hasTopics(tag) {
    return tag.count >= 1;
  },

  @discourseComputed("tag.count")
  topicCount(count) {
    if (count > 1) {
      return `${count} ${I18n.t(themePrefix("topics"))}`;
    } else {
      return `${count} ${I18n.t(themePrefix("topic"))}`;
    }
  },
})