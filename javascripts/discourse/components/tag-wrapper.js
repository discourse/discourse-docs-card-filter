import Component from "@ember/component";
import { service } from "@ember/service";
import { tagName } from "@ember-decorators/component";
import discourseComputed from "discourse/lib/decorators";
import { i18n } from "discourse-i18n";

@tagName("")
export default class TagWrapper extends Component {
  @service router;

  @discourseComputed("tagOrders", "tag.id")
  order(orders, id) {
    if (orders[id] && orders[id].split("-").length > 0) {
      if (
        this.listOrder.includes(orders[id].split("-")[0].trim().toLowerCase())
      ) {
        return orders[id].split("-")[0].trim().toLowerCase();
      }
    }

    return null;
  }

  @discourseComputed("tagOrders", "tag.id")
  ascending(orders, id) {
    if (orders[id] && orders[id].split("-").length > 1) {
      if (orders[id].split("-")[1].trim().toLowerCase().startsWith("a")) {
        return true;
      }
    }

    return false;
  }

  @discourseComputed("tagIcons", "tag.id")
  tagIcon(tagIcons, id) {
    return tagIcons[id];
  }

  @discourseComputed("tag.id")
  tagTitle(tagTitle) {
    return tagTitle.replaceAll("-", " ");
  }

  @discourseComputed("tag")
  hasTopics(tag) {
    return tag.count >= 1;
  }

  @discourseComputed("tag.count")
  topicCount(count) {
    if (count > 1) {
      return `${count} ${i18n(themePrefix("topics"))}`;
    } else {
      return `${count} ${i18n(themePrefix("topic"))}`;
    }
  }
}
