Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310BD3D03C4
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Jul 2021 23:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbhGTUfq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 20 Jul 2021 16:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235238AbhGTU3F (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 20 Jul 2021 16:29:05 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C83C061767;
        Tue, 20 Jul 2021 14:09:40 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id w2so10774380qvh.13;
        Tue, 20 Jul 2021 14:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xAR3CTRKfX4JIGDK45soYaGIQy2kUk2KowfF/DLMbpk=;
        b=KUGvBKe3rD2Y5OgxqLkKudt79Vaw4+fQRksrrjy1vjAS+3FMWIH7efHlPpH1BUTcYY
         fLbWEYc2DHp5+Yn/jCHDREjoSS/n6C5sClfH0cQd3zjqzehRZE/Ziom2aR3d4/fd9nIA
         Vsvdq9CTn/Euig8jv1XJB563PEmhtLEF8iP8kRxRyOv+5m70BDkvBUzMcwYGZDR3Az4G
         /m47g4nmY1UC480D8UE2Tq03pYLQ67662WyYM/qf9sbFchhnIwS85dNTw1Lg8f8UIz8B
         iDSaesnWbzbrSosw70r/kubKyotZHYmyE2w1ByuvjgxHT5bPltgGl8dP9pf68ZrxYj1G
         i+/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xAR3CTRKfX4JIGDK45soYaGIQy2kUk2KowfF/DLMbpk=;
        b=YXm6c/iV8wTE07IHSu3J1IK/Aj+FUKeTyJreF/8urHPWsbfw7xBj27fc5LeYUnRxav
         b0qYYNzfPdX+/ZqeJ7EEx5wIEZwlkxQsPSPqU4vrE+tSA9s7UvPqxSWGgORZ4s9ICIMB
         2XJDbHZdcRK4NZBogWxpwOOS2iIqfEVKyh+Y50tF3VjY0YqgAypTQo7FYE16pbNC8Ehf
         xpdQwl096BPColqaM4lNU8O5TUuEoRkPe+/I5OWbx6mhoPAlGEKe4oTNMfLhZxwlHXku
         iQNCYgY+11/hZBq16rT0RSJ3VVVnh3DcBS773R6C/TjCdNt7Qjs8Yy/YTcTfLrnLqtj7
         8GHA==
X-Gm-Message-State: AOAM532Dh6cUT9TYxvb5FD9fDHTHJUpm3CGkuCcbHmXhXN4VVae3MV4Z
        Y9mxWVxpsRv3hBNJP/djoUjrv1wHn8jg
X-Google-Smtp-Source: ABdhPJxrmetxGfx0Zh49bNjydeDdB5AUjMFV+eTdAwXlfDXqbbGyKI0rx6Wur1NSXcQPh0wu+2jdJg==
X-Received: by 2002:ad4:56e4:: with SMTP id cr4mr32501653qvb.54.1626815379609;
        Tue, 20 Jul 2021 14:09:39 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id j7sm10284938qkd.21.2021.07.20.14.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 14:09:38 -0700 (PDT)
Date:   Tue, 20 Jul 2021 17:09:35 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     linux-bcache@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs snapshots
Message-ID: <YPc7j2tW+ZkfBAeH@moria.home.lan>
References: <alpine.LRH.2.21.2107200122520.27704@pop.dreamhost.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.2107200122520.27704@pop.dreamhost.com>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Jul 20, 2021 at 01:28:33AM +0000, Eric Wheeler wrote:
> Hi Kent,
> 
> I read your bcachefs snapshots doc recently, it looks like you've put a 
> lot of thought into it.  Is it ready for testing?  
> 
> We use a lot of btrfs snapshots of VM images but the performance is pretty 
> poor and I'm looking forward to trying out bcachefs snapshots when it is 
> ready to try out.
> 
> We also have many dm-thin deployments backed by /dev/bcache0 volumes that 
> work quite well, but dm-thin meta is always an ongoing maintenance issue.
> (Don't run out of dm-thin meta space or *boom*!)
> 
> If bcachefs can replace dm-thin with loopback files (or even better, 
> native bcachefs devices!) then I look forward to getting beyond
> dm-thin into something more scalable.

It's not ready just yet - but the initial performance numbers are _extremely_
encouraging, I'll be posting more soon!
