Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3708621A462
	for <lists+linux-bcache@lfdr.de>; Thu,  9 Jul 2020 18:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgGIQIL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 9 Jul 2020 12:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgGIQIL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 9 Jul 2020 12:08:11 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576CCC08C5CE;
        Thu,  9 Jul 2020 09:08:11 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id t7so1173858qvl.8;
        Thu, 09 Jul 2020 09:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RL3laJwxnPjhE7RAJOQbdD6GPteuo9y8Lqjv1D5+rVA=;
        b=hnozVTMXIyrC863i8JgpVVm+XidXd3YYtkAFtjqDrTnZ63IyDRtXwRJwFjzCJFYSjw
         7joIyvWqTMfglJVKR82nWbC/FeyzfykAfY6gPhlewjbCxDh/1oroBZlhf72wgvp4PX83
         cifPUGUMeEiJ0TnKyCd4q0hmqQWy0b5EfM+7FUZHwJSaqVtcGOC24IrCMkW0DOiIWNUy
         pBbDxIOA84A6BL6jTB41fbxZO6RwNpbYXFehor7rkJ/ZYkI/NsKjq0QwsGwEkp3gG23E
         JNn19zJ5UZVr6KoVej7Hqp3R6irXeBBnAGzJ+OaAjuUHKcBhqxzItgy+YFPO+G3Zs9x4
         i7TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RL3laJwxnPjhE7RAJOQbdD6GPteuo9y8Lqjv1D5+rVA=;
        b=kYniQsrRGuKaT8q0VM1SJ6T/ipkC9g1xXT2yv1k8www1Abs6BuCFmmpWQ5rxQMGHez
         XUK6fxg6FEXss+74sEoiAb7298L4uKWCudysUcYUY8AvfRz42pnwEihS8+Y5J/3BPLtP
         riYjq8FVpXkyy8wcCc+TjV3hLOLzh34neY5AtaoymltesYNiUWe1LxG4/hOHOGqYAZuj
         mWXolyxQWR/XCSF8U7ccUnEgWeMDoW+J0ovq4FhaAiHK4mHPul0+LDzSmXCR1QrH8rjg
         LaN0ZTNyVMp4RhuyPHYdykPlv4zqaIvFUBqOZ1gEPkqgR9WXnGWGmFbOAVGIrjoXmkyn
         ZhuQ==
X-Gm-Message-State: AOAM531RnEyijZz3GpypqOa8FOOCzELQDrvgOQ0brXgUTtVJP4gAFdCm
        5Ch2ZlfBD6TgcSolboyS7A==
X-Google-Smtp-Source: ABdhPJwXB0H/6I7CjlZt17EB23xuy0cFSVFUnB7q3TsYi/rcxzLylhrgu2ibKUJK0JiWhEfOfAGsIA==
X-Received: by 2002:a0c:dc8e:: with SMTP id n14mr13074462qvk.136.1594310890534;
        Thu, 09 Jul 2020 09:08:10 -0700 (PDT)
Received: from zaphod.evilpiepirate.org ([2601:19b:c500:a1:56b:8096:bb6:ca58])
        by smtp.gmail.com with ESMTPSA id p25sm4440914qtk.67.2020.07.09.09.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 09:08:10 -0700 (PDT)
Date:   Thu, 9 Jul 2020 12:08:05 -0400
From:   kent.overstreet@gmail.com
To:     Stefan K <shadow_7@gmx.net>
Cc:     linux-bcache@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: how does the caching works in bcachefs
Message-ID: <20200709160805.GA158619@zaphod.evilpiepirate.org>
References: <2308642.L3yuttUQlX@t460-skr>
 <20200708220220.GA109921@zaphod.evilpiepirate.org>
 <2900215.XKtEbqh0OK@t460-skr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2900215.XKtEbqh0OK@t460-skr>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Jul 09, 2020 at 03:20:14PM +0200, Stefan K wrote:
> Hi and thanks!
> 
> > LRU, same as bcache.
> do you plan to change this , since LRU is not very efficient (in comparison to
> other), maybe 2Q or ARC[1-4]

No, but I'd be happy to help if someone else wanted to implement a new caching
algorithm :)

In real world mixed workloads LRU is fine, it's not that much of a difference
vs. the more sophisticated algorithms. More important is the stuff like
sequential_bypass or some other kind of knob to ensure your backup process
doesn't blow away the entire cache.

> 
> > [...]
> > And you can pin specific files/folders to a device, by setting foreground target
> > to that device and setting background target and promote target to nothing.
> ok thank you very much! That must be documented somewhere ;-)

I just write code, not documentation :)
