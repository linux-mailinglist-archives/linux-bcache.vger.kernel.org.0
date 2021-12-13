Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C87473768
	for <lists+linux-bcache@lfdr.de>; Mon, 13 Dec 2021 23:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240036AbhLMWXE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 13 Dec 2021 17:23:04 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:33064
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234623AbhLMWXE (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 13 Dec 2021 17:23:04 -0500
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 409B43F1AF
        for <linux-bcache@vger.kernel.org>; Mon, 13 Dec 2021 22:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639434183;
        bh=TbFtYhwQl+ZSk4zD3FnC7Lqh3DtGKoUGxedugxOYErQ=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=uSG+pgCLfvsVJ6J8gJSZQY+1AUYb9cLPSn3hOf47gtY1KZ/VRB4YNgUcydBiZLNv/
         PCJqsQ0fNDNIhljc0GPkTtqxoLn6+D4btalsYn1w4YgmVYfD2LPqUeNBXb+8wgv028
         P5XfWCCkDns0zJ4+WwhLUGvFHbNhcDpdqo+p73zpwzKIYyDQMfRjKfsqUE8uTTTxEr
         pkRkc/ufZQDyxJOwUiUcGBq0ik/wF6eh7OAyVMVceNwbK4abOp6AmjLLW0J+q8F8eq
         nXpBMhI2ltxiv4gbewCE8wWWXuWqyUIdAFyP9uI1Un14KrnItvKXMgoOfoR4cRO8BN
         7n9vmM7WTKTdg==
Received: by mail-pl1-f199.google.com with SMTP id y6-20020a17090322c600b001428ab3f888so5155461plg.8
        for <linux-bcache@vger.kernel.org>; Mon, 13 Dec 2021 14:23:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TbFtYhwQl+ZSk4zD3FnC7Lqh3DtGKoUGxedugxOYErQ=;
        b=xwQ81yaL/68uQqqPkXLGOnI9JgyjfLdORNRVOyZnxGlP1Vitjpl9Y7YNvNRshz5VuL
         1Bi+C8oIeZ+c8fnxNZJ3pXLwFdrEkgpS4kwnjzqrd9Ys8SL08m1UVzgeLVxKafB2kC/B
         yTSAGYAlFCJ/cN9v5t7zYVys4Q1gTPWV9m5oWKZo21B24KNjRZX532734jZGAWmq4RM8
         SkmCczAa6GUSycZgFWXSY0lobLP1DtZSKN2aRlhU71BZ18NTVaBrcSF6gDBRKCQ8owi3
         uyHi+7iUL+tEh2OSMnSrgo7k8BXSu5r8o0/SZYzhBsDVnZ0lKCCxqKk1N+Bj5LGAPAV3
         eBxg==
X-Gm-Message-State: AOAM530jgh4AI8PzKyshjRjR9eGqUo7tZG6KmuWl7sPi37G1oiS1tjvk
        NavY9SmeVvJza3Jw8jOgVYuVLYsLSdf20RHaqZbrZlzMH7Yh1QZHXdBOYTuIykeQOKvxmYQIj0S
        Cag0HU40Ewgm71ndw4dCLBptZBIqI2zRJqb+GxdemDCKs6t7cYLtIRIURiQ==
X-Received: by 2002:a05:6a00:179d:b0:4b1:4aba:397b with SMTP id s29-20020a056a00179d00b004b14aba397bmr830452pfg.66.1639434178772;
        Mon, 13 Dec 2021 14:22:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx+qjl2ehszEJWSJCZ4yN0Z5aJE4po6vBRMMTxT/xEnO3GTZuZcZoc/Yny7HIb+LE+KHpALQchtxahAbBdXsq0=
X-Received: by 2002:a05:6a00:179d:b0:4b1:4aba:397b with SMTP id
 s29-20020a056a00179d00b004b14aba397bmr830436pfg.66.1639434178449; Mon, 13 Dec
 2021 14:22:58 -0800 (PST)
MIME-Version: 1.0
References: <YY/+YDSjdZPma3oT@moria.home.lan> <20211213220455.1633987-1-mfo@canonical.com>
In-Reply-To: <20211213220455.1633987-1-mfo@canonical.com>
From:   Mauricio Faria de Oliveira <mfo@canonical.com>
Date:   Mon, 13 Dec 2021 19:22:45 -0300
Message-ID: <CAO9xwp3=aGDb095AirmKdY2hsnnuP0uKGxXWLhS91CN8kr44oA@mail.gmail.com>
Subject: Re: bcache-register hang after reboot
To:     kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, nkshirsagar@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Dec 13, 2021 at 7:04 PM Mauricio Faria de Oliveira
<mfo@canonical.com> wrote:
> It turns out that, at least for the disk image that reproduces the issue,
> the closure from bch_btree_set_root() to bch_journal_meta() doesn't make
> a difference; the stall is in bch_journal() -> journal_wait_for_write().

Sorry, I forgot to add the replied-to message. This is the message/context: [1]

[1] https://lore.kernel.org/linux-bcache/YY%2F+YDSjdZPma3oT@moria.home.lan/
