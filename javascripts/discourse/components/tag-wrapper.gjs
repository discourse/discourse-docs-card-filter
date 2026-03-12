/* eslint-disable ember/no-classic-components */
import Component from "@ember/component";
import { hash } from "@ember/helper";
import { computed } from "@ember/object";
import { LinkTo } from "@ember/routing";
import { tagName } from "@ember-decorators/component";
import icon from "discourse/helpers/d-icon";
import { i18n } from "discourse-i18n";

@tagName("")
export default class TagWrapper extends Component {
  @computed("tagOrders", "tag.name")
  get order() {
    if (
      this.tagOrders[this.tag?.name] &&
      this.tagOrders[this.tag?.name].split("-").length > 0
    ) {
      if (
        this.listOrder.includes(
          this.tagOrders[this.tag?.name].split("-")[0].trim().toLowerCase()
        )
      ) {
        return this.tagOrders[this.tag?.name]
          .split("-")[0]
          .trim()
          .toLowerCase();
      }
    }

    return null;
  }

  @computed("tagOrders", "tag.name")
  get ascending() {
    if (
      this.tagOrders[this.tag?.name] &&
      this.tagOrders[this.tag?.name].split("-").length > 1
    ) {
      if (
        this.tagOrders[this.tag?.name]
          .split("-")[1]
          .trim()
          .toLowerCase()
          .startsWith("a")
      ) {
        return true;
      }
    }

    return false;
  }

  @computed("tagIcons", "tag.name")
  get tagIcon() {
    return this.tagIcons[this.tag?.name];
  }

  @computed("tag.name")
  get tagTitle() {
    return this.tag?.name?.replaceAll("-", " ");
  }

  @computed("tag")
  get hasTopics() {
    return this.tag.count >= 1;
  }

  @computed("tag.count")
  get topicCount() {
    if (this.tag?.count > 1) {
      return `${this.tag?.count} ${i18n(themePrefix("topics"))}`;
    } else {
      return `${this.tag?.count} ${i18n(themePrefix("topic"))}`;
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
