Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF504179036
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Mar 2020 13:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbgCDMWb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Mar 2020 07:22:31 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36125 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729175AbgCDMWb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Mar 2020 07:22:31 -0500
Received: by mail-wm1-f66.google.com with SMTP id g83so1662104wme.1;
        Wed, 04 Mar 2020 04:22:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q4OymnKlRoZmf3mKRD2agRIM9Z7dNIfnoDwZz6qpqqQ=;
        b=Y5x+F8FnpOC4qfZ6ym/4SoWU7acOXQbSVLNAmo+pinCQaGJg0vgGKy8zx+1o0B1OkA
         HWj5TtVpyCY/9pyFu08TKXM56DlR12O4wuFCdjBRw0UhluIqIP67C7k1DZ5+EJax9uhK
         NQSh8aEvNHcuU3+vD6R0apdm3NZ70NrYQluCFDx8XQfVGIrl1TRJumZSZjBsangnxgji
         rwWpaX/jhwterCGKAs2bR/QwVucqmikKnmYxQ388QPFQ4aSX4znWl5L5bqJuhUxawsqy
         6pBLCyJ/Rig2+k0fHIM/Mj5OQXL+9uP+hn8b9PfV2HRy/98bTQMBhmGwvd1u7+hdBM8T
         FzXg==
X-Gm-Message-State: ANhLgQ1FeuFsezVmmRD3XLSD0LtZVDl3cvEI93arQLa9CI5oQvvW2z3R
        AJjnWZwNvjqTnlUVNDDuWO4=
X-Google-Smtp-Source: ADFU+vtY0thopSig62px/BMmnSWQmrAsKvLfPUidGMOeUfo9m6zMSpKyCVoKkopW14gs2iZbR1OT5w==
X-Received: by 2002:a1c:a949:: with SMTP id s70mr3502046wme.77.1583324547855;
        Wed, 04 Mar 2020 04:22:27 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id f17sm29002193wrj.28.2020.03.04.04.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 04:22:26 -0800 (PST)
Date:   Wed, 4 Mar 2020 13:22:26 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Coly Li <colyli@suse.de>, axboe@kernel.dk,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        hare@suse.de, mkoutny@suse.com
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
Message-ID: <20200304122226.GJ16139@dhcp22.suse.cz>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
 <20200302134919.GB9769@redhat.com>
 <20200303080544.GW4380@dhcp22.suse.cz>
 <20200303121918.GA27520@redhat.com>
 <20200303160307.GI4380@dhcp22.suse.cz>
 <20200304113613.GA13170@redhat.com>
 <20200304115718.GI16139@dhcp22.suse.cz>
 <20200304121324.GC13170@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304121324.GC13170@redhat.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed 04-03-20 13:13:25, Oleg Nesterov wrote:
> On 03/04, Michal Hocko wrote:
> >
> > So what would be a legit usecase to drop all signals while explicitly
> > calling allow_signal?
> 
> Not sure I understand...

flush_signals will simply drop all pending signals on the floor so there
is no way to handle them, right? I am asking when is still really a
desirable thing to do when you allow_signal for the kthread. The only
one I can imagine is that the kthread allows a single signal so it is
quite clear which signal is flushed.

kernel_dequeue_signal on the other hand will give you a signal and so
the code can actually handle it in some way.

-- 
Michal Hocko
SUSE Labs
