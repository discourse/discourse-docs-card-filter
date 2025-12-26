import Component from "@ember/component";
import { hash } from "@ember/helper";
import { LinkTo } from "@ember/routing";
import { tagName } from "@ember-decorators/component";
import icon from "discourse/helpers/d-icon";
import discourseComputed from "discourse/lib/decorators";
import { i18n } from "discourse-i18n";

@tagName("")
export default class TagWrapper extends Component {
  @discourseComputed("tagOrders", "tag.name")
  order(orders, name) {
    if (orders[name] && orders[name].split("-").length > 0) {
      if (
        this.listOrder.includes(orders[name].split("-")[0].trim().toLowerCase())
      ) {
        return orders[name].split("-")[0].trim().toLowerCase();
      }
    }

    return null;
  }

  @discourseComputed("tagOrders", "tag.name")
  ascending(orders, name) {
    if (orders[name] && orders[name].split("-").length > 1) {
      if (orders[name].split("-")[1].trim().toLowerCase().startsWith("a")) {
        return true;
      }
    }

    return false;
  }

  @discourseComputed("tagIcons", "tag.name")
  tagIcon(tagIcons, name) {
    return tagIcons[name];
  }

  @discourseComputed("tag.name")
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

  <template>
    <LinkTo
      @route="docs.index"
      @query={{hash
        tags=this.tag.name
        order=this.order
        ascending=this.ascending
      }}
      class="docs-card-box tag-card card-{{this.tag.name}}"
    >
      <div class="docs-card-box-header">
        {{#if this.tagIcon}}
          {{icon this.tagIcon}}
        {{else}}
          {{icon "tag" class="card-tag-icon"}}
        {{/if}}
        <h3 class="docs-card-box-header-title">{{this.tagTitle}}</h3>
      </div>

      <span class="docs-card-box-count">{{this.topicCount}}</span>
    </LinkTo>
  </template>
}
