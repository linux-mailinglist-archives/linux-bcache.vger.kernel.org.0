Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07B7361F43
	for <lists+linux-bcache@lfdr.de>; Fri, 16 Apr 2021 14:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbhDPMCW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 16 Apr 2021 08:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233955AbhDPMCW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 16 Apr 2021 08:02:22 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D3FC061574
        for <linux-bcache@vger.kernel.org>; Fri, 16 Apr 2021 05:01:56 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id o123so18203444pfb.4
        for <linux-bcache@vger.kernel.org>; Fri, 16 Apr 2021 05:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Nlwm5oBPcozztWhDnHBmZ3FOanUvUsMljuyTpGmR4ak=;
        b=Lmpmjo2CV2hkepVmKNkD6XFT9/9ZMWi3NS8ObapbH6ftHjCkMuQLE63erPALRtJCVu
         Eb7Oob3jBF92AfrEswgvy06yykWNXV6n0zxGo3hp/+B8pKUURpzQNqR+8O/PByHJ1Agz
         hBzu2sMeQNQjI4hRx6HmxAbwzKT9aDoEvlQphT+xF8PSrShyPD9dAoSCvScixdhIkqze
         6/vy6ItBm8jmZEBeDYryiP9D7j491JaNweew05S3P7kvIMwXaGBD101burPrhkqRVtPG
         8rVkQj7I+Lu6stcizt4GrD+WmC19tv3UxYMJs1S7WOeZ+0yko14tPFFxpZj9aCdWWEm9
         4H3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nlwm5oBPcozztWhDnHBmZ3FOanUvUsMljuyTpGmR4ak=;
        b=WIh8mzlZKmu41nGiObemqzqDpKjC4bTn3d+GsKcGz/4NETIO9XSGKncnyeO3ehXV7h
         TlcWCO913f3fYAaygtEFWDq6nqS4CP/6GCyxf3/5GO0sstQ1YiJ9PNx/FVafitIreyQ5
         NUerPw9/XtHmte3i8rvQYVQvyO7wnaZI23G7O2e/6SjWgEtZjEgmVipM83YDj3rbbWHp
         sVRlLgspquvLCvGU6IJKL+SKQTllKy8+whxntNLrfZTf4bPgDGQTK0v5Yk+5xmtfHc0G
         EJscvbJ6RwgKeiBsTTiCwWMrIzfyPnydEN35sU4Khta29vXg8ohFAAPrHSkhmIQyWxYt
         YPVQ==
X-Gm-Message-State: AOAM530lvfTn4/5V2JoM6zTeinOHi211faPc3nNVagrfgcGGpu2dakmb
        u0Dhw5NUefd06IdQeYMh2vw2nA==
X-Google-Smtp-Source: ABdhPJzB+9D4aQd7geRA/NwytFHoQqtPSJP7j5IwK3OjxGy15FDgUc3wFp+r/XFeBuUIEh1yNbj6fQ==
X-Received: by 2002:a63:4f59:: with SMTP id p25mr7719908pgl.21.1618574516094;
        Fri, 16 Apr 2021 05:01:56 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t67sm4917308pfb.210.2021.04.16.05.01.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 05:01:55 -0700 (PDT)
Subject: Re: [PATCH 13/13] bcache: use div_u64() in init_owner_info()
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        jianpeng.ma@intel.com, qiaowei.ren@intel.com,
        kernel test robot <lkp@intel.com>
References: <20210414054648.24098-1-colyli@suse.de>
 <20210414054648.24098-14-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5fb40457-e1d1-cf45-e8a3-c4c88f575221@kernel.dk>
Date:   Fri, 16 Apr 2021 06:01:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210414054648.24098-14-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/13/21 11:46 PM, Coly Li wrote:
> Kernel test robot reports the built-in u64/u32 in init_owner_info()
> doesn't work for m68k arch, the explicit div_u64() should be used.
> 
> This patch explicit uses div_u64() to do the u64/u32 division on
> 32bit m68k arch.

This should just be folded into `bcache: initialization of the buddy`
instead of being a separate patch. This is basically identical to what
we talked about for the 1st series, just fold in patches that fix
issues in that very series. No point in having them separate.

-- 
Jens Axboe

