Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81AF6114FC2
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Dec 2019 12:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbfLFL1z (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Dec 2019 06:27:55 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41518 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfLFL1y (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Dec 2019 06:27:54 -0500
Received: by mail-qk1-f195.google.com with SMTP id g15so6169047qka.8;
        Fri, 06 Dec 2019 03:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Z4CN9fWGotVCjAArImhBjXMRVm09OV2w4zsXX0KuWI=;
        b=IXQBj90HIneMNtWZswYpWP98F7SqiEnWbRYoNYgYuPwA564LsMjy91pUKBE8JsOk3G
         YP1ElfUQLeUbk8buj1sWYOfx4mYdiw/3cmYqpy+4smHkvmSncbNrdsRwjDBKhQRLXPoW
         iJiD6IxTrUZ+iXvZsffhCJr3Z04m+5HliJmcRattN8ttoizgh/pJ5x8Kw3kM1zJ+wlyf
         2Z7RGvL4MslV84zWF3tbtKWODwFbrVXF0m4AbgguIjwT0d8zpcHNaTbCCHLeuRWacnvU
         7KHwAo2R5DlRkqPYCsGamfCiIuTenRMyIYh/ypzs7Vm8+uma9A3DQlLLeVw5b3xMhYSj
         O6KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Z4CN9fWGotVCjAArImhBjXMRVm09OV2w4zsXX0KuWI=;
        b=cDQ8i1P0AJRoNOMsvVSPYrLyYgi2bSmctTxLm7CwSUwSQZTnkyLy2q5OZvqIKZw/Pq
         8B73p9YhOhiRzF2S13ooOopVThgqkcgtIf7WFXyLbCsm2UoafkhMLeyicHCaT6izBvz+
         CW5sRCpME0axvcAfE4/Kukt9Ffd+E3Nr4Sj2xcflT4WsDic+6Nom9VyjXyeHs4LiyTMV
         3wu2QSQKkjGYJVFrgAsEuvE3dZInHBpojSF8/bgHOaCG6F3aHkgyJ+gBui2AhV6Cp5+O
         lZQzPcKsmwvgaf8rGqAymeWRg7poQ+9ahhwEpvyivIuk1TVbgx9RQ1V3ihNN7gJ9aBgO
         FvVA==
X-Gm-Message-State: APjAAAWt9y2T7Ph2VaD7ZtSn3Qw5S8BMYxCyHibipTQDKCIznVMSGeNB
        qDt6Ed21p3kagKcKfIe67oPg+xDTDAQMev59XW0=
X-Google-Smtp-Source: APXvYqxDRdt37tVsjBZYXB8vOj4FS3C7CElFjw3jGITmX7h0nzpalhYP1MKzASxn+VZ+9rfVZZ4xjOHAL3yCgjdhSms=
X-Received: by 2002:a37:a613:: with SMTP id p19mr12855756qke.199.1575631673840;
 Fri, 06 Dec 2019 03:27:53 -0800 (PST)
MIME-Version: 1.0
References: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com> <20191206092713.GB7650@infradead.org>
In-Reply-To: <20191206092713.GB7650@infradead.org>
From:   Liang C <liangchen.linux@gmail.com>
Date:   Fri, 6 Dec 2019 19:27:42 +0800
Message-ID: <CAKhg4tKw9XbtMmUokYCus0H6ESkhrcxudT6wSgLwFa+kfwatzg@mail.gmail.com>
Subject: Re: [PATCH 1/2] [PATCH] bcache: cached_dev_free needs to put the sb page
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Sure. I will make a patch to clean up all the occurrences of this
usages later. Thanks.

On Fri, Dec 6, 2019 at 5:27 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Fri, Dec 06, 2019 at 04:55:42PM +0800, Liang Chen wrote:
> > Same as cache device, the buffer page needs to be put while
> > freeing cached_dev.  Otherwise a page would be leaked every
> > time a cached_dev is stopped.
> >
> > Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> > ---
> >  drivers/md/bcache/super.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > index 77e9869345e7..a573ce1d85aa 100644
> > --- a/drivers/md/bcache/super.c
> > +++ b/drivers/md/bcache/super.c
> > @@ -1275,6 +1275,9 @@ static void cached_dev_free(struct closure *cl)
> >
> >       mutex_unlock(&bch_register_lock);
> >
> > +     if (dc->sb_bio.bi_inline_vecs[0].bv_page)
> > +             put_page(bio_first_page_all(&dc->sb_bio));
>
> Using bio_first_page_all in the put_page call, but open coding it
> for the check looks rather strange.
>
> The cleanest thing here would be to just add a page pointer to the
> cached device structure and use that instead of all the indirections.
